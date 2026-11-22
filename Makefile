TARGET := iphone:clang:16.5:14.0
ARCHS = arm64
INSTALL = 0
include $(THEOS)/makefiles/common.mk
APPLICATION_NAME = Stopwatch
Stopwatch_FILES = $(wildcard src/*.m)
Stopwatch_FRAMEWORKS = UIKit Foundation CoreGraphics
Stopwatch_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/application.mk
