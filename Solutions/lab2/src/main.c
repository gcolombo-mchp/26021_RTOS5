/*
 * Copyright (c) 2016 Intel Corporation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

//#include <stdio.h>
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>

#include <zephyr/console/console.h>
#include <zephyr/input/input.h>

#define SW0_CODE DT_PROP(DT_NODELABEL(button0), zephyr_code)

/* 1000 msec = 1 sec */
#define SLEEP_TIME_MS   1000

/* The devicetree node identifier for the "led0" alias. */
#define LED0_NODE DT_ALIAS(led0)

/*
 * A build error on this line means your board is unsupported.
 * See the sample documentation for information on how to fix this.
 */
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);

static void input_cb(struct input_event *event, void *user_data)
{
    if (event->code == SW0_CODE) {
        if (event->value) {
            printk("Button pressed!\n");
        }
    }
	return;
}
INPUT_CALLBACK_DEFINE(NULL, input_cb, NULL);

int main(void)
{
	int ret;
	bool led_state = true;

	if (!gpio_is_ready_dt(&led)) {
		return 0;
	}

	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
	if (ret < 0) {
		return 0;
	}

	ret = console_init();
	if (ret<0)
	{
		return 0;
	}
	printk("\nPress T on the keyboard to toggle the LED 0\n - or -\nPress SW0 on the board to receive a message\n\n");
	
    while (1) {
        unsigned char chr = console_getchar();
        if (chr == 'T' ) {
            ret = gpio_pin_toggle_dt(&led);
            if (ret < 0) {
               return 0;
            }
    
            led_state = !led_state;
            printf("LED state: %s\n", led_state ? "ON" : "OFF");
            // k_msleep(SLEEP_TIME_MS);
        }
        else {
            printk("Received character: %c\n", chr);
        }
    }
	
	return 0;
}
