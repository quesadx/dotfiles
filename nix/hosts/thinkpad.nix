{ ... }:

{
  #services.udev.extraRules = ''
  # ACTION=="add", ENV{ID_INPUT_TOUCHSCREEN}=="1", ATTRS{name}=="ELAN901C:00 04F3:2CBF", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  #'';
}
