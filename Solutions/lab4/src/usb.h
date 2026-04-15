#include <zephyr/usb/usbd.h>
// #include <zephyr/drivers/uart.h>

#include <zephyr/usb/class/usbd_hid.h>
extern const struct device *hid_dev;

//extern const struct device *cdc_dev;

extern bool managed_vbus;
int init_usb_device(void);

void manage_usb_device(bool connected);

typedef struct {
    uint8_t buf[128];
    uint16_t length; 
} vcp_buffer;
extern vcp_buffer data_to_send;

int hid_get_report_cb(const struct device *dev, const uint8_t type, const uint8_t id, const uint16_t len, uint8_t *const buf);
int hid_set_report_cb(const struct device *dev, const uint8_t type, const uint8_t id, const uint16_t len, const uint8_t *const buf);
void hid_output_report_cb(const struct device *dev, const uint16_t len, const uint8_t *const buf);
void hid_input_report_done_cb(const struct device *dev, const uint8_t *const report);
