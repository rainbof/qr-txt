#!/bin/bash

ACCOUNT="CZ0420100000002601029991"

check_dependencies() {
    echo "[*] Kontrola qrencode..."

    if ! command -v qrencode >/dev/null 2>&1; then
        echo "[FAIL] qrencode nenalezen"
        return 1
    fi

    echo "[OK] qrencode nalezen"

    return 0
}

install_dependencies() {
    function warning_end() {
        local ret=$1
        echo "------------------------------"
        echo "Nezapomen si zmenit cislo uctu v promene ACCOUNT v tomto skriptu."
        echo "------------------------------"
        return ${ret:-0}
    }   

    echo "nezapomen si zmenit cislo uctu v promene ACCOUNT v tomto skriptu"

    if [[ -n "$TERMUX_VERSION" ]]; then
        echo "[*] Detekovan Termux"

        # Check if qrencode is already installed
        if ! command -v qrencode >/dev/null 2>&1; then
            echo "[*] Instaluji qrencode..."
            pkg update -y || warning_end 1
            pkg install -y libqrencode || warning_end 1
        fi

        echo "[OK] Instalace dokoncena"

    elif command -v apt >/dev/null 2>&1; then
        echo "[*] Detekovan apt"

        # Check if qrencode is already installed
        if ! command -v qrencode >/dev/null 2>&1; then
            echo "[*] Instaluji qrencode..."
            sudo apt update || warning_end 1
            sudo apt install -y libqrencode qrencode || warning_end 1
        fi

        echo "[OK] Instalace dokoncena"

    elif command -v pkg >/dev/null 2>&1; then
        echo "[*] Detekovan pkg"

        # Check if qrencode is already installed
        if ! command -v qrencode >/dev/null 2>&1; then
            echo "[*] Instaluji qrencode..."
            pkg update -y || warning_end 1
            pkg install -y libqrencode || warning_end 1
        fi

        echo "[OK] Instalace dokoncena"

    else
        echo "[FAIL] Nepodporovany package manager"
        warning_end 1
    fi
    warning_end 0
}

read_amount() {
    read -rp "Castka: " amount
    echo "$amount"
}

read_message() {
    read -rp "Text pro prijemce: " message
    echo "$message"
}

generate_qr() {

    amount=$(read_amount)
    message=$(read_message)

    spd="SPD*1.0*ACC:${ACCOUNT}*AM:${amount}.00"

    [[ -n "$message" ]] && \
        spd="${spd}*MSG:${message}"

    echo
    echo "[*] Generuji QR platbu..."
    echo
    qrencode -m 2 -t ANSIUTF8 "${spd}"
}

case "$1" in

    --check)
        check_dependencies
        ;;

    --install)
        install_dependencies
        ;;
    --test)

        SPD='SPD*1.0*ACC:CZ0420100000002601029991*AM:50.00*MSG:neco neco neco neco neco neco neco'

        for margin in 1 2 4; do
            for ecc in L M H; do
                for type in ANSIUTF8 UTF8 ANSI ASCII; do

                    echo
                    echo "=== margin=${margin} ecc=${ecc} type=${type} ==="
                    echo

                    qrencode \
                        -m "${margin}" \
                        -l "${ecc}" \
                        -t "${type}" \
                        "${SPD}"

                done
            done
        done

    ;;
    *)
        check_dependencies || {
            echo
            echo "Spust:"
            echo "  zaplat --install"
            exit 1
        }

        generate_qr
        ;;
esac