#include <zephyr/usb/usbd.h>
#include <zephyr/drivers/uart.h>
extern const struct device *cdc_dev;

extern bool managed_vbus;
int init_usb_device(void);

void manage_usb_device(bool connected);

typedef struct {
    uint8_t buf[128];
    uint16_t length; 
} vcp_buffer;
extern vcp_buffer data_to_send;
