/*
 * Copyright (c) 2016 Intel Corporation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

//#include <stdio.h>
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>

// #include <zephyr/console/console.h>
#include <zephyr/input/input.h>

#include "usb.h"

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

vcp_buffer data_to_send;
vcp_buffer received_data;

#define VBUS_CODE DT_PROP(DT_NODELABEL(vbus0), zephyr_code)

static void input_cb(struct input_event *event, void *user_data)
{

    if (!managed_vbus) {
        if (event->code == VBUS_CODE) {
            if (event->value) {
                manage_usb_device(true);
            }
            else {
                manage_usb_device(false);
            }
        }
    }

    if (event->code == SW0_CODE) {
        if (event->value) {
            // printk("Button pressed!\n");

            data_to_send.length = sprintf(data_to_send.buf, "Button pressed!\n\r");
            uart_irq_tx_enable(cdc_dev);
        
        }
    }
    return;
}
INPUT_CALLBACK_DEFINE(NULL, input_cb, NULL);

void uart_irq_cb(const struct device *dev, void *user_data) 
{
    static bool led_state = true;
    while (uart_irq_update(dev) && uart_irq_is_pending(dev)) {
     
        if (uart_irq_rx_ready(dev)) {
            received_data.length = uart_fifo_read(dev, received_data.buf, sizeof(received_data.buf));
            if (received_data.length > 0) {
                if (received_data.buf[0] == 'T') {
                    gpio_pin_toggle_dt(&led);
                    led_state = !led_state;
                    data_to_send.length = sprintf(data_to_send.buf, "LED state: %s\n\r", led_state ? "ON" : "OFF");
                } 
                else {
                    data_to_send.length = sprintf(data_to_send.buf, "Received character: %c\n\r", received_data.buf[0]);
                }
                uart_irq_tx_enable(dev);
            }
        }

        if (uart_irq_tx_ready(dev)) {
            uart_fifo_fill(dev, data_to_send.buf, data_to_send.length);
            uart_irq_tx_disable(dev);
        }
        
    }
}

static const struct gpio_dt_spec vbus_gpio = GPIO_DT_SPEC_GET(DT_NODELABEL(vbus0), gpios);

int main(void)
{
	int ret;
	// bool led_state = true;

	if (!gpio_is_ready_dt(&led)) {
		return 0;
	}

	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
	if (ret < 0) {
		return 0;
	}

	// ret = console_init();
	// if (ret<0)
	// {
	// 	return 0;
	// }
	// printk("\nPress T on the keyboard to toggle the LED 0\n - or -\nPress SW0 on the board to receive a message\n\n");
	
    if (!device_is_ready(cdc_dev)) {
        return 0;
    }
    ret = init_usb_device();
    if (ret <0) {
        return 0;
    }

    uart_irq_callback_set(cdc_dev, uart_irq_cb);
    uart_irq_rx_enable(cdc_dev);

    if (!managed_vbus) {
        if (gpio_pin_get_dt(&vbus_gpio)) {
            manage_usb_device(true);
        }
    }
    
    while (1) {
        // unsigned char chr = console_getchar();
        // if (chr == 'T' ) {
        //     ret = gpio_pin_toggle_dt(&led);
        //     if (ret < 0) {
        //        return 0;
        //     }
    
        //     led_state = !led_state;
        //     printf("LED state: %s\n", led_state ? "ON" : "OFF");
        k_msleep(SLEEP_TIME_MS);
        // }
        // else {
        //     printk("Received character: %c\n", chr);
        // }
    }
	
	return 0;
}
