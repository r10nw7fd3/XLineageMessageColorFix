ANDROID_JAR=/opt/android/platforms/android-33/android.jar
JAVACFLAGS=-source 1.8 -target 1.8 -cp $(ANDROID_JAR):api-82.jar
OUT=XLineageMessageColorFix.apk
KEYSTORE?=debug.jks

SRC=$(wildcard *.java)
CLS=$(SRC:.java=.class)

all: $(OUT)

$(OUT): classes.dex $(OUT).unaligned
	zip -uq $(OUT).unaligned classes.dex
	zipalign -f -p 4 $(OUT).unaligned $(OUT)
	apksigner sign --ks $(KEYSTORE) $(OUT)

api-82.jar:
	curl -OLs https://github.com/rovo89/XposedBridge/raw/gh-pages/de/robv/android/xposed/api/82/api-82.jar
	echo "35866b507b360d4789ff389ad7386b6e8bbf6cc4  api-82.jar" | sha1sum -c

classes.dex: $(CLS)
	d8 --lib $(ANDROID_JAR) --release --no-desugaring $(CLS)

$(OUT).unaligned: classes.dex AndroidManifest.xml
	aapt2 link -o $(OUT).unaligned -A assets -I $(ANDROID_JAR) --manifest AndroidManifest.xml

# I really wanted to implement incremental compilation
#%.class: %.java api-82.jar
#	javac $(JAVACFLAGS) $<

$(CLS): $(SRC) api-82.jar
	javac $(JAVACFLAGS) $(SRC)

clean:
	rm -rf $(CLS) classes.dex $(OUT) $(OUT).unaligned $(OUT).idsig api-82.jar

genkey:
	keytool -genkey -keystore $(KEYSTORE) -keyalg RSA -keysize 2048

install: $(OUT)
	adb install $(OUT)

.PHONY: all clean genkey install
