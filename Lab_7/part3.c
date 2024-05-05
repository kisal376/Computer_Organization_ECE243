/* This files provides address values that exist in the system */

#define SDRAM_BASE            0xC0000000
#define FPGA_ONCHIP_BASE      0xC8000000
#define FPGA_CHAR_BASE        0xC9000000

/* Cyclone V FPGA devices */
#define LEDR_BASE             0xFF200000
#define HEX3_HEX0_BASE        0xFF200020
#define HEX5_HEX4_BASE        0xFF200030
#define SW_BASE               0xFF200040
#define KEY_BASE              0xFF200050
#define TIMER_BASE            0xFF202000
#define PIXEL_BUF_CTRL_BASE   0xFF203020
#define CHAR_BUF_CTRL_BASE    0xFF203030

/* VGA colors */
#define WHITE 0xFFFF
#define YELLOW 0xFFE0
#define RED 0xF800
#define GREEN 0x07E0
#define BLUE 0x001F
#define CYAN 0x07FF
#define MAGENTA 0xF81F
#define GREY 0xC618
#define PINK 0xFC18
#define ORANGE 0xFC00

#define ABS(x) (((x) > 0) ? (x) : -(x))

/* Screen size. */
#define RESOLUTION_X 320
#define RESOLUTION_Y 240

/* Constants for animation */
#define BOX_LEN 2
#define NUM_BOXES 8

#define FALSE 0
#define TRUE 1

#include <stdlib.h>
#include <stdio.h>

// Begin part3.c code for Lab 7
void wait_for_vsync();
void clear_screen();
void draw_line(int x1, int y1, int x2, int y2, short int line_color);
void draw_vertical(int y1, int y2, int x, short int line_color);
void plot_pixel(int x, int y, short int line_color);
void draw_box(int x, int y, short int color);

volatile int pixel_buffer_start; // global variable
short int colours[10] = {WHITE, YELLOW, RED, GREEN, BLUE, CYAN, MAGENTA, GREY, PINK, ORANGE};

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    // declare other variables(not shown)
    int box_x[NUM_BOXES];
    int box_y[NUM_BOXES];
    int box_x_prev[NUM_BOXES];
    int box_y_prev[NUM_BOXES];
    int box_x_prev_prev[NUM_BOXES];
    int box_y_prev_prev[NUM_BOXES];
    int box_colour[NUM_BOXES];
    int dx[NUM_BOXES];
    int dy[NUM_BOXES];

    // initialize location and direction of rectangles(not shown)
    for (int i = 0; i < NUM_BOXES; i ++){
      dx[i] = ((rand() % 2) * 2) - 1;
      dy[i] = ((rand() % 2) * 2) - 1;

      box_x[i] = (rand() % 319);
      box_y[i] = (rand() % 239);
      box_x_prev[i] = box_x[i];
      box_y_prev[i] = box_y[i];
      box_x_prev_prev[i] = box_x[i];
      box_y_prev_prev[i] = box_y[i];

      box_colour[i] = (rand() % 10);
    }

    /* set front pixel buffer to start of FPGA On-chip memory */
    *(pixel_ctrl_ptr + 1) = 0xC8000000; // first store the address in the
                                        // back buffer
    /* now, swap the front/back buffers, to set the front buffer location */
    wait_for_vsync();
    /* initialize a pointer to the pixel buffer, used by drawing functions */
    pixel_buffer_start = *pixel_ctrl_ptr;
    clear_screen(); // pixel_buffer_start points to the pixel buffer
    /* set back pixel buffer to start of SDRAM memory */
    *(pixel_ctrl_ptr + 1) = 0xC0000000;
    pixel_buffer_start = *(pixel_ctrl_ptr + 1); // we draw on the back buffer
    clear_screen();


    while (1){

        /* Erase any boxes and lines that were drawn in the last iteration */
        for (int i = 0; i < NUM_BOXES; i ++){

          draw_box(box_x_prev[i], box_y_prev[i], 0);
          draw_line(box_x_prev[i], box_y_prev[i], box_x_prev[(i + 1) % NUM_BOXES], box_y_prev[(i + 1) % NUM_BOXES], 0);

        }

        // code for updating the locations of boxes (not shown)
        for (int i = 0; i < NUM_BOXES; i ++){
          if (box_x[i] == 0){
            dx[i] = 1;
          }
          if (box_x[i] == 318){
            dx[i] = -1;
          }
          if (box_y[i] == 0){
            dy[i] = 1;
          }
          if (box_y[i] == 238){
            dy[i] = -1;
          }

          box_x[i] = box_x[i] + dx[i];
          box_y[i] = box_y[i] + dy[i];
        }

        // code for drawing the boxes and lines (not shown)
        for (int i = 0; i < NUM_BOXES; i ++){

          draw_box(box_x[i], box_y[i], colours[box_colour[i]]);
          draw_line(box_x[i], box_y[i], box_x[(i + 1) % NUM_BOXES], box_y[(i + 1) % NUM_BOXES], colours[box_colour[i]]);
          box_x_prev[i] = box_x[i];
          box_y_prev[i] = box_y[i];
        }

        wait_for_vsync(); // swap front and back buffers on VGA vertical sync
        pixel_buffer_start = *(pixel_ctrl_ptr + 1); // new back buffer

        /* Erase any boxes and lines that were drawn in the last iteration */
        for (int i = 0; i < NUM_BOXES; i ++){

          draw_box(box_x_prev_prev[i], box_y_prev_prev[i], 0);
          draw_line(box_x_prev_prev[i], box_y_prev_prev[i], box_x_prev_prev[(i + 1) % NUM_BOXES], box_y_prev_prev[(i + 1) % NUM_BOXES], 0);

        }
        // code for updating the locations of boxes (not shown)
        for (int i = 0; i < NUM_BOXES; i ++){
          if (box_x[i] == 0){
            dx[i] = 1;
          }
          if (box_x[i] == 318){
            dx[i] = -1;
          }
          if (box_y[i] == 0){
            dy[i] = 1;
          }
          if (box_y[i] == 238){
            dy[i] = -1;
          }

          box_x[i] = box_x[i] + dx[i];
          box_y[i] = box_y[i] + dy[i];
        }

        // code for drawing the boxes and lines (not shown)
        for (int i = 0; i < NUM_BOXES; i ++){

          draw_box(box_x[i], box_y[i], colours[box_colour[i]]);
          draw_line(box_x[i], box_y[i], box_x[(i + 1) % NUM_BOXES], box_y[(i + 1) % NUM_BOXES], colours[box_colour[i]]);
          box_x_prev_prev[i] = box_x[i];
          box_y_prev_prev[i] = box_y[i];
        }

        wait_for_vsync(); // swap front and back buffers on VGA vertical sync
        pixel_buffer_start = *(pixel_ctrl_ptr + 1); // new back buffer
    }
}

// code for subroutines (not shown)
void wait_for_vsync(){

  volatile int * pixel_ctrl_ptr = (int *)0xFF203020;

    *pixel_ctrl_ptr = 1;

    int status = *(pixel_ctrl_ptr + 3);

    while ((status & 0x01) != 0){

      status = *(pixel_ctrl_ptr + 3);

    }
}
void clear_screen(){
  for (int i = 0; i < 320; i ++){
    for (int j = 0;  j < 240; j ++){
      plot_pixel(i, j, 0);
    }
  }
}
void draw_line(int x1, int y1, int x2, int y2, short int line_color){

  float delta_x = x2 - x1 + 0.0;
  float delta_y = y2 - y1 + 0.0;

  if (delta_x == 0){
    draw_vertical(y1, y2, x1, line_color);
    return;
  }

  float m = delta_y / delta_x;

  int start_x;
  int start_y;
  int end_x;
  int end_y;
  int point_to_plot;
  double point_to_plot_temp;

  if (ABS(m) <= 1){

    if (x1 <= x2){

      start_x = x1;
      start_y = y1;
      end_x = x2;

    }else{

      start_x = x2;
      start_y = y2;
      end_x = x1;

    }


    for (int i = 0; i < end_x - start_x + 1; i ++){

      point_to_plot_temp = start_y + (m * i);

      point_to_plot = point_to_plot_temp;

      if (point_to_plot_temp - point_to_plot > 0.5){

        point_to_plot = point_to_plot_temp + 1;

      }

      plot_pixel (i + start_x, point_to_plot, line_color);
    }

  }else{

    if (y1 <= y2){

      start_y = y1;
      start_x = x1;
      end_y = y2;

    }else{

      start_y = y2;
      start_x = x2;
      end_y = y1;

    }

    for (int i = 0; i < end_y - start_y + 1; i ++){

      point_to_plot_temp = start_x + (i)/m;

      point_to_plot = point_to_plot_temp;

      if (point_to_plot_temp - point_to_plot > 0.5){

        point_to_plot = point_to_plot_temp + 1;

      }

      plot_pixel (point_to_plot, i + start_y, line_color);
    }
  }
}
void draw_vertical(int y1, int y2, int x, short int line_color){

  int start_y;
  int end_y;

  if (y1 < y2){

    start_y = y1;
    end_y = y2;

  }else{

    start_y = y2;
    end_y = y1;

  }
  for (int i = 0; i < end_y - start_y + 1; i ++){

    plot_pixel (x, i + start_y, line_color);
  }
}
void draw_box(int x, int y, short int color){

    for (int i = 0; i < BOX_LEN; i ++){
      for (int j = 0;  j < BOX_LEN; j ++){
        plot_pixel(x + i, y + j, color);
      }
    }

  }
void plot_pixel(int x, int y, short int line_color){

  *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;

}
