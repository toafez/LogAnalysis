# Copyright (c) 2000-2020 Synology Inc. All rights reserved.

## You can use CC CFLAGS LD LDFLAGS CXX CXXFLAGS AR RANLIB READELF STRIP after include env.mak
include /env.mak

EXEC= LogAnalysis
OBJS= LogAnalysis.o

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

install: $(EXEC)
	mkdir -p $(DESTDIR)/usr/local/bin/
	install $< $(DESTDIR)/usr/local/bin/

clean:
	rm -rf *.o $(EXEC)
