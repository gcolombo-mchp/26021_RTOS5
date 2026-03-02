// #include <stdio.h>
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/console/console.h>

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

static struct gpio_callback button_cb_data;

static void debounce_expired(struct k_work *work)
{
	ARG_UNUSED(work);
	printk("Button pressed!\n");
	gpio_pin_interrupt_configure_dt(&button, GPIO_INT_EDGE_TO_ACTIVE);
}

static K_WORK_DELAYABLE_DEFINE(debounce, debounce_expired);

void button_pressed(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{
	/* debounce delay for the button */
    gpio_pin_interrupt_configure_dt(&button, GPIO_INT_DISABLE);
	k_work_reschedule(&debounce, K_MSEC(100));
}

int main(void)
{
	int ret;
	bool led_state = true;
   	unsigned char chr;

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

	ret = console_init();
	if (ret<0)
	{
		return 0;
	}

	printk("\n\rPress T on the keyboard to toggle the LED 1\n\r - or -\n\rPress SW2 on the board to receive a message\n\n\r");
	
	while (1) {
		chr = console_getchar();
		if (chr == 'T')
		{
			ret = gpio_pin_toggle_dt(&led);
			if (ret < 0) {
				return 0;
			}

			led_state = !led_state;
			printf("LED state: %s\n", led_state ? "ON" : "OFF");
			// k_msleep(SLEEP_TIME_MS);
		}
		else
		{
			printk("Received character: %c\n", chr);
		}
	}
	return 0;
}