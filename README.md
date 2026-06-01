# CUPS Docker Image with brlaser (Brother HL-1200 series)

CUPS Docker image based on [ydkn/cups](https://hub.docker.com/r/ydkn/cups) (Debian)
with the **brlaser** driver for **Brother HL-1200 / HL-1210W / HL-1212W** printers.

The Brother proprietary driver for this series is 32-bit (i386) and its LPR filter
fails silently on 64-bit systems without `libc6:i386` — CUPS marks the job as
"completed" but nothing is printed. **brlaser** is a free, native 64-bit driver that
makes printing on this series reliable.

## Build

```bash
docker build -t cups-brlaser .
```

## Usage

The printer is USB, so the USB device must be passed to the container:

```bash
docker run -d --restart always \
  --name cups-brlaser \
  -p 631:631 \
  -e ADMIN_PASSWORD=mySecretPassword \
  --device /dev/usb/lp0 \
  -v $(pwd):/etc/cups \
  cups-brlaser
```

If `/dev/usb/lp0` does not exist, pass the whole USB bus with `--device /dev/bus/usb`.

## Configuration

Open the CUPS web interface on port 631 (e.g. https://localhost:631) and add the printer.
Default credentials: `admin` / `admin` (set `ADMIN_PASSWORD` to change it).

Under **Make/Model**, select **`Brother HL-1200 series, using brlaser v6`**.
Do **not** pick a proprietary "Brother ... CUPS" PPD or a "Generic" one.

## License

GPL-3.0 — see [LICENSE](LICENSE).
