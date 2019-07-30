# cross-compile Win64 libs and tools under Linux

PREFIX=/c/mingw-w64/x86_64-8.1.0-posix-seh-rt_v6-rev0/mingw64/bin/

SRC_DIR=src
OSDEP_DIR=src-osdep/windows
OUT_DIR=bin
CFLAGS="-Wno-implicit-function-declaration \
       -I${OSDEP_DIR} \
       -Iinclude \
       -DMINGW \
       -Iinclude/zlib \
       -O2 \
	   -fpic \
       "
LDFLAGS="-L./ -larvid_client -L./lib-osdep/win64 -lz -lws2_32"

echo "prefix = ${PREFIX}"
rm libarvid_client.*
rm -rf ${OUT_DIR}
mkdir -p ${OUT_DIR}

# compile arvid-client library
${PREFIX}gcc -c ${CFLAGS} ${OSDEP_DIR}/tsync.c -o ${OUT_DIR}/tsync.o
${PREFIX}gcc -c ${CFLAGS} ${SRC_DIR}/crc.c -o ${OUT_DIR}/crc.o
${PREFIX}gcc -c ${CFLAGS} -O2 ${SRC_DIR}/arvid_client.c -o ${OUT_DIR}/arvid_client.o
${PREFIX}ar rcs libarvid_client.a ${OUT_DIR}/tsync.o ${OUT_DIR}/crc.o ${OUT_DIR}/arvid_client.o
${PREFIX}gcc -shared ${CFLAGS} -o arvid_client.dll ${OUT_DIR}/tsync.o ${OUT_DIR}/crc.o ${OUT_DIR}/arvid_client.o ${LDFLAGS}

# compile tools
${PREFIX}gcc ${CFLAGS} -o ${OUT_DIR}/demo.exe ${SRC_DIR}/demo.c ${LDFLAGS}
${PREFIX}gcc ${CFLAGS} -o ${OUT_DIR}/fw_upload.exe ${SRC_DIR}/fw_upload.c ${LDFLAGS}



