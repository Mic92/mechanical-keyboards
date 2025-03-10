# Get the source

```console
$ git clone https://github.com/Mic92/qmk_firmware $HOME/qmk_firmware
```

# To flash

## Keychron K6 Pro

(bluetooth_playground branch)

```console
$ qmk flash -kb keychron/k6_pro/ansi/white -km via-mic92
```

## Keychron Q12

(master branch)

Bootloader mode: Press `Esc` while plugging in power cable

```
$ qmk flash -kb keychron/q12/ansi_encoder -km default
```

## Aurora Sofle v2

```
$ nix run .#flash --builders ""
```
