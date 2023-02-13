// Copyright (c) 2000-2020 Synology Inc. All rights reserved.

#include <sys/sysinfo.h>
#include <syslog.h>
#include <stdio.h>

int main(int argc, char** argv) {
	struct sysinfo info;
	int ret;

	ret = sysinfo(&info);
	if (ret != 0) {
		syslog(LOG_SYSLOG, "Failed to get info\n");
		return -1;
	}

	syslog(LOG_SYSLOG, "[LogAnalysis] %s package ...", argv[1]);
	syslog(LOG_SYSLOG, "[LogAnalysis] Total Ram: %u\n", (unsigned int)info.totalram);
	syslog(LOG_SYSLOG, "[LogAnalysis] Free RAM: %u\n", (unsigned int)info.freeram);

	return 0;
}
