#include "usb.h"
//const struct device *cdc_dev = DEVICE_DT_GET(DT_NODELABEL(cdc_acm_uart));

const struct device *hid_dev = DEVICE_DT_GET(DT_NODELABEL(hid0));

USBD_DEVICE_DEFINE(usbd_ctx, DEVICE_DT_GET(DT_NODELABEL(zephyr_udc0)), 0x04D8, 0x003F);

USBD_DESC_LANG_DEFINE(lang_desc);
USBD_DESC_MANUFACTURER_DEFINE(mfr_desc, "Microchip Technology Inc.");
USBD_DESC_PRODUCT_DEFINE(prod_desc, "Zephyr vendor HID");
USBD_DESC_SERIAL_NUMBER_DEFINE(sn_desc);

USBD_DESC_CONFIG_DEFINE(fs_cfg_desc, "FS Configuration");
USBD_CONFIGURATION_DEFINE(fs_config, USB_SCD_SELF_POWERED, 50, &fs_cfg_desc);

void usb_msg_callback(struct usbd_context *const ctx, const struct usbd_msg *const msg)
{
    if (usbd_can_detect_vbus(ctx)) {
        switch (msg->type)
        {
        case USBD_MSG_VBUS_READY:
            manage_usb_device(true);
            break;
        case USBD_MSG_VBUS_REMOVED:
            manage_usb_device(false);
            break;
        default:
            break;
        }
    }
}

bool managed_vbus;

const uint8_t hid_report_descriptor[] = {
    0x06, 0x00, 0xFF,      // Usage Page (Vendor Defined 0xFF00)
    0x09, 0x01,            // Usage (Vendor Usage 1)
    0xA1, 0x01,            // Collection (Application)

    // Input Report: 64 bytes (to host)
    0x15, 0x00,            //   Logical Minimum (0)
    0x25, 0xFF,            //   Logical Maximum (255)
    0x75, 0x08,            //   Report Size (8 bits/element)
    0x95, 0x40,            //   Report Count (64 elements)
    0x09, 0x01,            //   Usage (Vendor Usage 1)
    0x81, 0x02,            //   Input (Data, Variable, Absolute)

    // Output Report: 64 bytes (to device)
    0x15, 0x00,            //   Logical Minimum (0)
    0x25, 0xFF,            //   Logical Maximum (255)
    0x75, 0x08,            //   Report Size (8 bits/element)
    0x95, 0x40,            //   Report Count (64 elements)
    0x09, 0x01,            //   Usage (Vendor Usage 1)
    0x91, 0x02,            //   Output (Data, Variable, Absolute)

    0xC0                   // End Collection
};

struct hid_device_ops hid_ops = {
    .get_report = hid_get_report_cb,
    .set_report = hid_set_report_cb,
    .input_report_done = hid_input_report_done_cb,
    .output_report = hid_output_report_cb,
};

int init_usb_device(void)
{

    int err = 0;
    err = usbd_add_descriptor(&usbd_ctx, &lang_desc);
    if (err) {
        return err;
    }
    err = usbd_add_descriptor(&usbd_ctx, &mfr_desc);
    if (err) {
        return err;
    }
    err = usbd_add_descriptor(&usbd_ctx, &prod_desc);
    if (err) {
        return err;
    }
    err = usbd_add_descriptor(&usbd_ctx, &sn_desc);
    if (err) {
        return err;
    }

    err = usbd_add_configuration(&usbd_ctx, USBD_SPEED_FS, &fs_config);
    if (err) {
        return err;
    }

    // err = usbd_register_class(&usbd_ctx, "cdc_acm_0", USBD_SPEED_FS, 1);
    // if (err) {
    //     return err;
    // }

    err = usbd_register_class(&usbd_ctx, "hid_0", USBD_SPEED_FS, 1);
    if (err) {
        return err;
    }
    err = hid_device_register(hid_dev, hid_report_descriptor, sizeof(hid_report_descriptor), &hid_ops);
    if (err) {
        return err;
    }
    err = usbd_device_set_code_triple(&usbd_ctx, USBD_SPEED_FS, 0, 0, 0);
    if (err) {
        return err;
    }

    err = usbd_msg_register_cb(&usbd_ctx, usb_msg_callback);
    if (err) {
        return err;
    }

    err = usbd_init(&usbd_ctx);
    if (err) {
        return err;
    }

    managed_vbus = usbd_can_detect_vbus(&usbd_ctx);
    return err;

}

void manage_usb_device(bool connected)
{

    if (connected) {
        usbd_enable(&usbd_ctx);
        // uint32_t dtr = 0;
        // while (!dtr) {
        //     uart_line_ctrl_get(cdc_dev, UART_LINE_CTRL_DTR, &dtr);
        //     k_sleep(K_MSEC(100));
        // }
        // data_to_send.length = sprintf(data_to_send.buf, "\nPress T on the keyboard to toggle the LED 0\n - or -\nPress SW0 on the board to receive a message\n\n");
        // uart_irq_tx_enable(cdc_dev);
    }
    else {
        usbd_disable(&usbd_ctx);
    }

}
