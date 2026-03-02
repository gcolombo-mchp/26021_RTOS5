#ifndef USB_H
#define USB_H

#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/usb/usb_device.h>
#include <zephyr/usb/usbd.h>
#include <zephyr/usb/class/usbd_hid.h>

/* Bulk EP Full-Speed size */
#define EP_SIZE 64

// extern const struct device *cdc_dev;
extern const struct device *hid_dev;

int init_usb_device(void);

#define HID_APP_REPORT_SIZE 64
#define HID_CMD_TOGGLE_LED  0x80
#define HID_CMD_READ_BUTTON 0x81

int hid_get_report_cb(const struct device *dev,
			          const uint8_t type, 
                      const uint8_t id, 
                      const uint16_t len,
			          uint8_t *const buf);

int hid_set_report_cb(const struct device *dev,
			          const uint8_t type, 
                      const uint8_t id, 
                      const uint16_t len,
			          const uint8_t *const buf);

void hid_output_report_cb(const struct device *dev,
                          const uint16_t len,
                          const uint8_t *const buf);

void hid_input_report_done_cb(const struct device *dev, 
                              const uint8_t *const report);

#endif /* USB_H */