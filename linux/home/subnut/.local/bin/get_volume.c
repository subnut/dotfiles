#include <math.h>
#include <stdio.h>
#include <stdbool.h>
#include <alsa/asoundlib.h>


/*
 * Copied directly from amixer/volume_mapping.c from the alsa-project repo
 * located at git://git.alsa-project.org/alsa-utils.git
 *
 * When copied, the file was last modified by commit 29ab061 on 3 Sep 2019
 */

#define MAX_LINEAR_DB_SCALE	24

static inline bool use_linear_dB_scale(long dBmin, long dBmax)
{
	return dBmax - dBmin <= MAX_LINEAR_DB_SCALE * 100;
}

enum ctl_dir { PLAYBACK, CAPTURE };

static int (* const get_dB_range[2])(snd_mixer_elem_t *, long *, long *) = {
	snd_mixer_selem_get_playback_dB_range,
	snd_mixer_selem_get_capture_dB_range,
};
static int (* const get_raw_range[2])(snd_mixer_elem_t *, long *, long *) = {
	snd_mixer_selem_get_playback_volume_range,
	snd_mixer_selem_get_capture_volume_range,
};
static int (* const get_dB[2])(snd_mixer_elem_t *, snd_mixer_selem_channel_id_t, long *) = {
	snd_mixer_selem_get_playback_dB,
	snd_mixer_selem_get_capture_dB,
};
static int (* const get_raw[2])(snd_mixer_elem_t *, snd_mixer_selem_channel_id_t, long *) = {
	snd_mixer_selem_get_playback_volume,
	snd_mixer_selem_get_capture_volume,
};
static int (* const set_dB[2])(snd_mixer_elem_t *, snd_mixer_selem_channel_id_t, long, int) = {
	snd_mixer_selem_set_playback_dB,
	snd_mixer_selem_set_capture_dB,
};
static int (* const set_raw[2])(snd_mixer_elem_t *, snd_mixer_selem_channel_id_t, long) = {
	snd_mixer_selem_set_playback_volume,
	snd_mixer_selem_set_capture_volume,
};

static double get_normalized_volume(snd_mixer_elem_t *elem,
				    snd_mixer_selem_channel_id_t channel,
				    enum ctl_dir ctl_dir)
{
	long min, max, value;
	double normalized, min_norm;
	int err;

	err = get_dB_range[ctl_dir](elem, &min, &max);
	if (err < 0 || min >= max) {
		err = get_raw_range[ctl_dir](elem, &min, &max);
		if (err < 0 || min == max)
			return 0;

		err = get_raw[ctl_dir](elem, channel, &value);
		if (err < 0)
			return 0;

		return (value - min) / (double)(max - min);
	}

	err = get_dB[ctl_dir](elem, channel, &value);
	if (err < 0)
		return 0;

	if (use_linear_dB_scale(min, max))
		return (value - min) / (double)(max - min);

	normalized = pow(10, (value - max) / 6000.0);
	if (min != SND_CTL_TLV_DB_GAIN_MUTE) {
		min_norm = pow(10, (min - max) / 6000.0);
		normalized = (normalized - min_norm) / (1 - min_norm);
	}

	return normalized;
}

double get_normalized_playback_volume(snd_mixer_elem_t *elem,
				      snd_mixer_selem_channel_id_t channel)
{
	return get_normalized_volume(elem, channel, PLAYBACK);
}
/* END Copy */


int
main(void)
{

	long dBvalue;
	long min, max;
	snd_mixer_t *handle;
	snd_mixer_elem_t *elem;
	snd_mixer_selem_id_t *sid;
	const char *card = "default";
	const char *selem_name = "Master";

	snd_mixer_open(&handle, 0);
	snd_mixer_attach(handle, card);
	snd_mixer_selem_register(handle, NULL, NULL);
	snd_mixer_load(handle);

	snd_mixer_selem_id_alloca(&sid);
	snd_mixer_selem_id_set_index(sid, 0);
	snd_mixer_selem_id_set_name(sid, selem_name);
	elem = snd_mixer_find_selem(handle, sid);

	// snd_mixer_selem_get_playback_volume_range(elem, &min, &max);

	snd_mixer_selem_channel_id_t chan = 0; // 0 = left, 1 = right
	printf("%i\n", (int)(get_normalized_playback_volume(elem, chan)*100));

	snd_mixer_close(handle);

}
