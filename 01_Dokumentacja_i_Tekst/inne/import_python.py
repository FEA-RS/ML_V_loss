# === 1. PODSTAWY (DANE I MATEMATYKA) ===
import numpy as np           # Podstawowe operacje na macierzach i liczbach
import pandas as pd          # Praca na tabelach danych, wczytywanie plików CSV/Excel
import os, sys               # Obsługa ścieżek do plików i systemu

# === 2. WIZUALIZACJA (WYKRESY) ===
import matplotlib.pyplot as plt # Podstawowe wykresy (funkcja straty, wyniki)
import seaborn as sns        # Ładniejsze wykresy statystyczne

# === 3. KLASYCZNE UCZENIE MASZYNOWE (SCIKIT-LEARN) ===
from sklearn.model_selection import train_test_split # Dzielenie danych na treningowe i testowe
from sklearn.preprocessing import StandardScaler      # Skalowanie danych (bardzo ważne!)
from sklearn.metrics import accuracy_score, confusion_matrix # Sprawdzanie jak dobrze działa model

# === 4. DEEP LEARNING (PYTORCH) - TWOJA MOC GPU ===
import torch                 # Główny silnik PyTorcha
import torch.nn as nn        # Tworzenie warstw sieci neuronowej (Linear, Conv2d itp.)
import torch.optim as optim  # Algorytmy optymalizacji (np. Adam, SGD)
from torch.utils.data import DataLoader, Dataset # Zarządzanie dużymi zbiorami danych

# === 5. OBRAZY I MULTIMEDIA (COMPUTER VISION) ===
import cv2                   # OpenCV - potężne narzędzie do obróbki obrazu i wideo
from PIL import Image        # Podstawowe otwieranie i edycja plików graficznych
import torchvision.transforms as T # Automatyczne przerabianie obrazów pod AI

# === 6. POMOCNICZE (MUST-HAVE) ===
from tqdm import tqdm        # Pasek postępu w pętlach (widzisz ile czasu zostało do końca)
import time                  # Mierzenie jak szybko działa Twój RTX 4090

# === 7. AUTOMATYCZNE WYKRYWANIE TWOJEGO RTX 4090 ===
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"Używam urządzenia: {device}")