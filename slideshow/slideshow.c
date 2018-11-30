/**
 * Jason White's joystick code (https://gist.github.com/jasonwhite/c5b2048c15993d285130) modified to be a slideshow app for the NES Classic
 */

#include <fcntl.h>
#include <stdio.h>
#include <linux/joystick.h>

int read_event(int fd, struct js_event *event) {
    ssize_t bytes;
    bytes = read(fd, event, sizeof(*event));
    if (bytes == sizeof(*event))
        return 0;
    return -1;
}

int file_exists(const char* filename) {
    struct stat buf;
    return (stat(filename, &buf) == 0);
}

void update_slide(int slide_num, int event_number) {
    char cmd[40];
    char filename_png[20];
    char filename_mp4[20];

    sprintf(filename_png, "./slide-%03d.png", slide_num);
    sprintf(filename_mp4, "./slide-%03d.mp4", slide_num);

    if (file_exists(filename_mp4) && (event_number < 9)) { // don't play videos on arrow-key navigation
            printf("MP4: slide-%03d.mp4 exists.\n", slide_num);
            sprintf(cmd, "./video.sh %s", filename_mp4);
            system(cmd);
    }

    if (file_exists(filename_png)) {
        printf("PNG: slide-%03d.png exists.\n", slide_num);
        sprintf(cmd, "./image.sh %s", filename_png);
        system(cmd);

    // } else if (file_exists(filename_mp4)) {
    //     printf("MP4: slide-%03d.mp4 exists.\n", slide_num);
    //     sprintf(cmd, "./video.sh %s", filename_mp4);
    //     system(cmd);

    // } else {
    //     printf("no PNG or MP4 exists for slide %03d - skipping!\n", slide_num);
    }
}

int main(int argc, char *argv[]) {
    // suspend NES UI/emulator
    system("./pause.sh");

    int slide = 0;
    int previous_event = 0;

    const char *device;
    int js;
    struct js_event event;

    if (argc > 1)
        device = argv[1];
    else
        device = "/dev/input/js0";

    js = open(device, O_RDONLY);

    if (js == -1)
        perror("Could not open joystick");

    printf("\n\n");

    while (read_event(js, &event) == 0) {
        // printf("Button Press: value: %02x, type: %02x, number: %02x\n", event.value, event.type, event.number);

        if (event.value) {
            if ((event.number == 1) || (event.number == 11)) {
                slide--;
                if (slide < 0) {
                    slide = 0;
                }

                printf("slide-- (is now %d)\n", slide);
                update_slide(slide, event.number);

            } else if ((event.number == 0) || (event.number == 12)) {
                slide++;
                printf("slide++ (is now %d)\n", slide);
                update_slide(slide, event.number);

            } else if (event.number == 8) {
                if (previous_event == 8) { // and this event is 8 (SELECT)
                    printf("Exiting due to double \"select\" press\n");

                    // resume NES UI/emulator
                    system("./resume.sh");

                    close(js);
                    return 0;
                }
            }

            previous_event = event.number;
        }
    }

    close(js);
    return 0;
}
