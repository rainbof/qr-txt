# qr-txt

Generátor textových QR kódů pro české bankovní platby (SPD formát).

## Instalace
Podpora: tmux, Debian, s troskou štěstí asi pojede na čemkoliv.

```bash
git clone git@github.com:rainbof/qr-txt.git
cd qr-txt
chmod +x zaplat.sh
./zaplat.sh --install
```

Většinou se to nainstaluje samo. Pokud ne, vyřeš co to chce tady:
```bash
./zaplat.sh --check
```

Pokud ani to ne, pokračuj do sekce [Troubleshoot](#troubleshoot).

## Použití

```bash
./zaplat.sh
```

Zadej:

 * Částku
 * Zprávu

a ukaž QR někomu, kdo má peníze.

## Formát

Generuje QR kód ve formátu SPD (Snadné platby domácností):
```
SPD*1.0*ACC:<IBAN>*AM:<ČÁSTKA>*CC:CZK*MSG:<POPIS>
```

## Požadavky

- `qrencode` (bude nainstalován automaticky)
- `bash`
- Štěstí na lidi s penězi

## Troubleshoot

Pokud se něco rozbije, bude to chybějící knihovna nebo chyba. Doporučuji plač a pak se zeptat svého AI agenta.
