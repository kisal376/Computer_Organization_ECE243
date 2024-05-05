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
#include <stdbool.h>

// Begin part1.s for Lab 7

void clear_screen();
void draw_line(int x1, int y1, int x2, int y2, short int line_color);
void draw_vertical(int y1, int y2, int x, short int line_color);


volatile int pixel_buffer_start; // global variable

int main(void)
{
  volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
  /* Read location of the pixel buffer from the pixel buffer controller */
  pixel_buffer_start = *pixel_ctrl_ptr;

  clear_screen();
  draw_line(0, 0, 150, 150, 0x001F);   // this line is blue
  draw_line(150, 150, 319, 0, 0x07E0); // this line is green
  draw_line(0, 239, 319, 239, 0xF800); // this line is red
  draw_line(319, 0, 0, 239, 0xF81F);   // this line is a pink color
}

// code not shown for clear_screen() and draw_line() subroutines

void plot_pixel(int x, int y, short int line_color)
{
  *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
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

// void draw_line(int x1, int y1, int x2, int y2, short int line_color){
//
//   bool is_steep = abs(y2 - y1) > abs(x2 - x1);
//   int swap;
//
//   if(is_steep){
//     swap = x1;
//     x1 = y1;
//     y1 = swap;
//
//     swap = x2;
//     x2 = y2;
//     y2 = swap;
//   }
//
//   if(x1 > x2){
//     swap = x1;
//     x1 = x2;
//     x2 = swap;
//
//     swap = y1;
//     y1 = y2;
//     y2 = swap;
//   }
//
//   int deltax = x2 - x1;
//   int deltay = abs(y2 - y1);
//   float error = -(deltax / 2.0);
//   int y = y1;
//   int y_step;
//
//   if (y1 < y2){
//
//     y_step = 1;
//
//   }else{
//
//     y_step = -1;
//
//   }
//
//   for(int x = x1; x < x2 + 1; x ++){
//     if(is_steep){
//       plot_pixel(y, x, line_color);
//     }
//     else{
//       plot_pixel(x, y, line_color);
//     }
//     error = error + deltay;
//     if(error >= 0){
//       y = y + y_step;
//       error = error - deltax;
//     }
//   }
// }
