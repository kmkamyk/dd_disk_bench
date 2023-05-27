#!/bin/bash

# Sprawdzenie liczby argumentów
if [[ $# -ne 1 ]]; then
  echo "Użycie: $0 <liczba_wątków>"
  exit 1
fi

# Pobranie argumentu
threads=$1

# Funkcja tworząca pliki o rozmiarze 1 GB
create_files() {
  local thread_id=$1
  while true; do
    # Tworzenie pliku o rozmiarze 1 GB
    dd if=/dev/zero of="file_$thread_id" bs=1G count=1 >/dev/null 2>&1
  done
}

# Pętla tworząca wątki
for (( i=1; i<=$threads; i++ )); do
  create_files "$i" &
done

# Funkcja do zakończenia skryptu
finish() {
  echo "Zatrzymywanie skryptu..."
  pkill -P $$  # Zabijanie procesów potomnych
  wait  # Oczekiwanie na zakończenie wątków
  rm -f file_*  # Usuwanie utworzonych plików
  exit
}

# Obsługa sygnałów SIGINT i SIGTERM
trap finish SIGINT SIGTERM

# Wyświetlanie informacji o działającym obciążeniu
echo "Obciążanie dysków w toku... Naciśnij Ctrl+C, aby zakończyć."

# Oczekiwanie na zakończenie skryptu (naciśnięcie Ctrl+C)
while true; do
  sleep 1
done
