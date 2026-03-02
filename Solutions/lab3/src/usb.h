#ifndef USB_H
#define USB_H

#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/usb/usb_device.h>
#include <zephyr/usb/usbd.h>

/* Bulk EP Full-Speed size */
#define EP_SIZE 64

extern const struct device *cdc_dev;

int init_usb_device(void);

#endif /* USB_H */