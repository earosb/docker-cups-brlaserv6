# CUPS + driver para Brother HL-1200 series (HL-1200 / HL-1210W / HL-1212W)
# Basada en ydkn/cups (Debian buster).
#
# Estrategia:
#   - Opcion A (RECOMENDADA, por defecto): brlaser. Driver libre, estable, sin libs de 32 bits.
#   - Opcion B (opcional): driver propietario de Brother con soporte i386 (descomenta el bloque).
#
# Nota: Debian buster esta archivado, por eso se apunta apt a archive.debian.org.

FROM ydkn/cups:latest

LABEL description="CUPS con driver brlaser para Brother HL-1200 series (unraid)"

# ---------------------------------------------------------------------------
# Opcion A: brlaser (recomendada)
# ---------------------------------------------------------------------------
RUN set -eux; \
    # buster esta EOL -> mover los repos a archive.debian.org y desactivar el check de fecha
    sed -i 's|deb.debian.org|archive.debian.org|g; s|security.debian.org|archive.debian.org|g; /buster-updates/d' /etc/apt/sources.list; \
    apt-get -o Acquire::Check-Valid-Until=false update; \
    apt-get install -y --no-install-recommends \
        printer-driver-brlaser \
        ghostscript \
        cups-filters \
        usbutils; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Opcion B (OPCIONAL): driver propietario de Brother con soporte 32 bits.
# Descomenta SOLO si necesitas el driver oficial de Brother en lugar de brlaser.
# Sustituye la URL/nombre del .deb por el modelo EXACTO de tu impresora
# (descargalo de https://support.brother.com -> tu modelo -> Linux).
# ---------------------------------------------------------------------------
# ARG BROTHER_DEB_URL="https://download.brother.com/welcome/dlf006893/hl1210wpdrv-3.0.1-1.i386.deb"
# RUN set -eux; \
#     dpkg --add-architecture i386; \
#     sed -i 's|deb.debian.org|archive.debian.org|g; s|security.debian.org|archive.debian.org|g; /buster-updates/d' /etc/apt/sources.list; \
#     apt-get -o Acquire::Check-Valid-Until=false update; \
#     apt-get install -y --no-install-recommends \
#         libc6:i386 libstdc++6:i386 \
#         wget ghostscript a2ps psutils; \
#     wget -O /tmp/brother.deb "$BROTHER_DEB_URL"; \
#     dpkg -i --force-all /tmp/brother.deb; \
#     rm -f /tmp/brother.deb; \
#     apt-get clean; \
#     rm -rf /var/lib/apt/lists/*

EXPOSE 631
