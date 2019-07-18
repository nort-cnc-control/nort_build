# nort_build
NoRT CNC control building scripts

# Building and installing

## Init repository

```
git submodule init
git submodule sync
git submodule update
cd cnccontrol_rt
git submodule init
git submodule sync
git submodule update
cd ..
```

## Build libraries, utils and MCU firmware

```
cd cnccontrol_rt/arch/stm32f103/libopencm3
make -j4
cd ../../../..
./build_host.sh
./build_target.sh
```

Libraries for host arch will be installed to ~/.local/. Set PREFIX env var to change location.

## Write MCU firmware

```
stm32flash -w build_target/cnccontrol_rt/arch/stm32f103/controller.bin /dev/ttyUSB0
```
