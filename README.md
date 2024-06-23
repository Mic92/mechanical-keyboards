# Get the source

```console
$ git clone https://github.com/Mic92/qmk_firmware $HOME/qmk_firmware
```

# To flash

## K6

```console
$ qmk flash -kb keychron/k6_pro/ansi/white -km via-mic92
```

## Q12

```
$ qmk flash -kb keychron/q12/ansi_encoder -km keychron
```

## Aurora Sofle v2

```
$ nix run .#flash --builders ""
```
