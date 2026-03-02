// #include <stdio.h>
// #include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
// #include <zephyr/console/console.h>
#include "usb.h"
#include <zephyr/drivers/uart.h>

/* 1000 msec = 1 sec */
#define SLEEP_TIME_MS   1000

/* The devicetree node identifier for the "led0" alias. */
// #define LED0_NODE DT_ALIAS(led0)
#define LED1_NODE DT_ALIAS(led1)
#define SWITCH2_NODE DT_ALIAS(sw2)

/*
 * A build error on this line means your board is unsupported.
 * See the sample documentation for information on how to fix this.
 */
// static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED1_NODE, gpios);
static const struct gpio_dt_spec button = GPIO_DT_SPEC_GET(SWITCH2_NODE, gpios);

/* Buffer and variables to receive and transmit */
struct{
	uint8_t rx_buf[64];
	uint16_t lenght;
} received_data;

struct {
	uint8_t tx_buf[128];
	uint16_t lenght; 
} data_to_send;

/* Callback interrupt CDC-ACM, using UART APIs */
static void uart_irq_callback(const struct device *dev, void *user_data) 
{
	int ret=0;
	static bool led_state = true;
    ARG_UNUSED(user_data);

	while (uart_irq_update(dev) && uart_irq_is_pending(dev)) {
    
			/* Handling of received data */
   		if (uart_irq_rx_ready(dev)) {
                
        	/* Read data from FIFO RX */
        	received_data.lenght = uart_fifo_read(dev, received_data.rx_buf, sizeof(received_data.rx_buf));
        
        	if (received_data.lenght > 0) {
				if (received_data.rx_buf[0] == 'T') {
					ret = gpio_pin_toggle_dt(&led);
					if (ret < 0) {
						return;
					}
					/* Print LED state*/
					led_state = !led_state;
					data_to_send.lenght = sprintf(data_to_send.tx_buf, "LED state: %s\n\r", led_state ? "ON" : "OFF");
				} 
				else {
					/* Print received character */
					data_to_send.lenght = sprintf(data_to_send.tx_buf, "Received character: %c\n\r", received_data.rx_buf[0]);
				}
				/* Enable transmission from beginning of the FIFO TX */
				uart_irq_tx_enable(dev);
        	}
    	}
    
    	/* Handle transmission */
    	if (uart_irq_tx_ready(dev)) {
			uint16_t sent;

			sent = uart_fifo_fill(dev, data_to_send.tx_buf, data_to_send.lenght);
			uart_irq_tx_disable(dev);
    	}
	}
}

static struct gpio_callback button_cb_data;

static void debounce_expired(struct k_work *work) 
{
	ARG_UNUSED(work);
	// printk("Button pressed!\n");
	data_to_send.lenght = sprintf(data_to_send.tx_buf, "Button pressed!\n\r");
	uart_irq_tx_enable(cdc_dev);
	gpio_pin_interrupt_configure_dt(&button, GPIO_INT_EDGE_TO_ACTIVE);
}

static K_WORK_DELAYABLE_DEFINE(debounce, debounce_expired);

void button_pressed(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{
	/* debounce delay for the button */
    gpio_pin_interrupt_configure_dt(&button, GPIO_INT_DISABLE);
	k_work_reschedule(&debounce, K_MSEC(100));
}

int main(void){
	int ret;
	// bool led_state = true;
   	// unsigned char chr; 

	if (!gpio_is_ready_dt(&led)) {
		return 0;
	}

	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
	if (ret < 0) {
		return 0;
	}

	if (!gpio_is_ready_dt(&button)) {
		return 0;
	}

	ret = gpio_pin_configure_dt(&button, GPIO_INPUT);
	if (ret < 0) {
		return 0;
	}

	ret = gpio_pin_interrupt_configure_dt(&button,
					      GPIO_INT_EDGE_TO_ACTIVE);
	if (ret != 0) {
		return 0;
	}

	gpio_init_callback(&button_cb_data, button_pressed, BIT(button.pin));
	gpio_add_callback(button.port, &button_cb_data);

	// ret = console_init();
	// if (ret<0)
	// {
	// 	return 0;
	// }

    /* Check if CDC-ACM device is ready */
    if (!device_is_ready(cdc_dev)) {
        return -1;
    }

    /* USB device stack initialization */
    ret = init_usb_device();
    if (ret) {
        return ret;
    }
    
    /* Registering the CDC-ACM callback using UART API */
    uart_irq_callback_user_data_set(cdc_dev, uart_irq_callback, NULL);
    
    /* Enable receiving interrupt */
    uart_irq_rx_enable(cdc_dev);
	
	uint32_t dtr = 0;
	while (!dtr)
	{
		uart_line_ctrl_get(cdc_dev, UART_LINE_CTRL_DTR, &dtr);
		k_sleep(K_MSEC(100));
	}
	
	//printk("\n\rPress T on the keyboard to toggle the LED 1\n\r - or -\n\rpress SW2 on the board to receive a message\n\n\r");
	data_to_send.lenght = sprintf(data_to_send.tx_buf, "\n\rPress T on the keyboard to toggle the LED 1\n\r - or -\n\rPress SW2 on the board to receive a message\n\n\r");
	uart_irq_tx_enable(cdc_dev);
	
	while (1) {
	// 	chr = console_getchar();
	// 	if (chr == 'T')
	// 	{
	// 		ret = gpio_pin_toggle_dt(&led);
	// 		if (ret < 0) {
	// 			return 0;
	// 		}

	// 		led_state = !led_state;
	// 		printf("LED state: %s\n", led_state ? "ON" : "OFF");*/
			k_msleep(SLEEP_TIME_MS);
	// 	}
	// 	else
	// 	{
	// 		printk("Received character: %c\n", chr);
	// 	}
	}
	return 0;
}
