**Circulate windows** (ie. keep nodes fixed. just circulate the windows.)  
NOTE: Focus shall stay fixed on the current **node**, not the current **window**
```zsh
bspc node @/ -C {backward,forward}
```

**Rotate layout**
```zsh
bspc node @/ -R {+,-}{90,180,270}
```

**Flip layout** (as shown in windelicato GIF)
```zsh
bspc node @/ -F {horizontal,vertical}
```

# `@/` is the root node of the current desktop
