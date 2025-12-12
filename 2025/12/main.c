#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	if (argc < 2) {
		perror("Please provide filepath.");
		exit(EXIT_FAILURE);
	}
	char *filepath = argv[1];
	FILE *file;
	if (NULL == (file = fopen(filepath, "rb"))) {
		perror("Can't open file.");
		exit(EXIT_FAILURE);
	}

	fseek(file, 0, SEEK_END);
	size_t flen = ftell(file) + 1;
	char *content = malloc(flen + 1);
	if (NULL == content) {
		perror("malloc failed");
		exit(EXIT_FAILURE);
	}
	fseek(file, 0, SEEK_SET);
	fread(content, flen, 1, file);
	if (!feof(file)) {
		perror("Not reading file properly");
		exit(EXIT_FAILURE);
	}
	content[flen] = 0;
	fclose(file);

	char *line = content;
	int total = 0;
	while (*line) {
		while (*line && *line != '\n' && (*line < '0' || *line > '9')) line++;
		if (!*line) break;

		int n = 0, m = 0;
		while (*line >= '0' && *line <= '9') {
			n = n * 10 + (*line - '0');
			line++;
		}
		if (*line == 'x') {
			line++;
			while (*line >= '0' && *line <= '9') {
				m = m * 10 + (*line - '0');
				line++;
			}
		} else {
			while (*line && *line != '\n') line++;
			if (*line == '\n') line++;
			continue;
		}

		while (*line && *line != ':') line++;
		if (*line == ':') line++;

		int sum = 0;
		while (*line && *line != '\n') {
			while (*line == ' ' || *line == '\t') line++;
			if (*line >= '0' && *line <= '9') {
				int num = 0;
				while (*line >= '0' && *line <= '9') {
					num = num * 10 + (*line - '0');
					line++;
				}
				sum += num * 9;
			} else if (*line == '\n' || !*line) {
				break;
			} else {
				line++;
			}
		}

		total += sum <= n * m ? 1 : 0;

		if (*line == '\n') line++;
	}

	printf("%d\n", total);

	free(content);
	return 0;
}
