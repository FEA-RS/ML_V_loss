# Notatka Metodologiczna: Dobór i Interpretacja Metryk Ocyny Modelu Predykcji $V_{loss}$

---

## 1. Strategia Doboru Metryk (Wariant 1)

W ocenie jakości modeli predykcji ubytku objętości gruntu ($V_{loss}$) przyjęto **podejście oparte na metrykach bezwzględnych oraz współczynniku determinacji**, odrzucając metryki względne (procentowe).

* **Przyjęty zestaw metryk:**
  * **MAE** (*Mean Absolute Error*) – błąd bezwzględny [jednostka: % $V_{loss}$]
  * **RMSE** (*Root Mean Squared Error*) – błąd kwadratowy [jednostka: % $V_{loss}$]
  * **$R^2$** (*Współczynnik determinacji*) – bezwymiarowa miara dopasowania [zakres: $(-\infty, 1]$]

* **Metryki wykluczone z tabel głównych:**
  * **RMAE** (*Relative Mean Absolute Error*)
  * **MAPE** (*Mean Absolute Percentage Error*)

---

## 2. Szczegółowe Uzasadnienie Odrzucenia Metryk Względnych (RMAE / MAPE)

### A. Problematyka matematyczna (Dzielenie przez wartości bliskie zeru)
Klasyczny wzór na względny błąd bezwzględny (RMAE) przyjmuje postać:

$$RMAE = \frac{MAE}{\frac{1}{n} \sum_{i=1}^{n} |y_i|} \cdot 100\%$$

gdzie $y_i$ to wartości rzeczywiste, a $MAE$ to średni błąd bezwzględny.

1. **Efekt małego mianownika:** W przypadku, gdy wartości rzeczywiste zmiennej docelowej $y_i$ dążą do zera ($y_i \to 0$), mianownik powyższego ułamka staje się bardzo małą liczbą.
2. **Sztuczna oscylacja wyniku:** Dzielenie przez liczbę bliską zeru powoduje matematyczną eksplozję wyniku procentowego, niezależnie od tego, jak mały jest fizyczny błąd predykcji w liczniku ($MAE$).
3. **Przykład z badań:** 
   * Na zbiorze testowym bezwzględny błąd modelu spada z $MAE = 0.033\%$ na $0.025\%$ (model fizycznie myli się o mniejszą wartość).
   * Mimo poprawy dokładności, wartość $RMAE$ drastycznie rośnie z $39.9\%$ do $96.9\%$.
   * Zjawisko to wynika wyłącznie z faktu, że średnia wartość ubytku gruntu w strefie testowej (ringi 226–285) spadła z poziomu $\approx 0.08\%$ do $\approx 0.026\%$.

### B. Zmiana dystrybucji danych (Data Drift / Spatial Shift)
Podział przestrzenny danych (ringi 1–225 vs. 226–285) wykazuje fizyczną zmianę warunków gruntowych:
* **Strefa treningowa:** Wysoka zmienność i wyższe wartości osiadań ($V_{loss} \in [0.00\%, 0.25\%]$).
* **Strefa testowa:** Strefa stabilna o znikimym ubytku gruntu ($V_{loss} \approx 0.00\% - 0.05\%$).

W strefie testowej sygnał przechodzi w szum o bardzo niskiej amplitudzie, co sprawia, że metryki procentowe tracą sens fizyczny i interpretacyjny.

---

> ### 📝 Gotowa wstawka do rozdziału o metodologii (do pracy magisterskiej):
> *"Z uwagi na charakterystykę fizyczną analizowanego zjawiska, w strefie testowej (ringi 226–285) wartości rzeczywiste ubytku objętości gruntu ($V_{loss}$) przyjmują wartości bliskie zeru. W związku z tym zaniechano stosowania względnych metryk błędu (takich jak RMAE czy MAPE). Metryki te, posiadając w mianowniku wartość zależną od średniej wielkości mierzonej zmiennej, ulegają sztucznemu zawyżeniu przy wartościach dążących do zera, co prowadzi do błędnej interpretacji zdolności predykcyjnej modelu. Ocena jakości została oparta na twardych metrykach bezwzględnych (MAE, RMSE) wyrażonych w jednostkach zmiennej docelowej oraz na współczynniku determinacji ($R^2$)."*

---

## 3. Szczegółowa Interpretacja Wybranych Metryk

### 3.1. MAE (Mean Absolute Error) – Średni Błąd Bezwzględny

* **Wzór:**
  $$MAE = \frac{1}{n} \sum_{i=1}^{n} |y_i - \hat{y}_i|$$

* **Co dokładnie mierzy:** Przeciętną różnicę między wartością rzeczywistą ($y_i$) a predykcją modelu ($\hat{y}_i$), traktując wszystkie błędy liniowo (z jednakową wagą).
* **Interpretacja w projekcie:**
  * Wynik $MAE = 0.018\%$ oznacza, że model LSTM pomylił się średnio o $0.018$ punktu procentowego ubytku objętości gruntu.
* **Zalety:** Wyjątkowo intuicyjny dla inżyniera/geotechnika; wyrażony bezpośrednio w jednostce badanej zmiennej.

---

### 3.2. RMSE (Root Mean Squared Error) – Pierwiastek Błędu Średniokwadratowego

* **Wzór:**
  $$RMSE = \sqrt{\frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2}$$

* **Co dokładnie mierzy:** Średnią rozbieżność predykcji, przy czym różnice są podnoszone do kwadratu przed uśrednieniem. Metryka ta nadaje większą wagę dużym błędom (*outlierom*).
* **Interpretacja w relacji do MAE:**
  * **Relacja $RMSE > MAE$:** Zawsze $RMSE \ge MAE$. Im większa różnica między $RMSE$ a $MAE$, tym bardziej błędy modelu są zróżnicowane i występują pojedyncze, duże odchylenia (tzw. "szpile" lub błędy skrajne).
  * *Przykład:* Dla LSTM na teście $MAE = 0.018\%$, a $RMSE = 0.030\%$. Różnica ta wskazuje, że model przeważnie trafia bardzo blisko wartości rzeczywistej, lecz zdarzają mu się pojedyncze punktowe przestrzały.

---

### 3.3. $R^2$ (Współczynnik Determinacji)

* **Wzór:**
  $$R^2 = 1 - \frac{\sum_{i=1}^{n} (y_i - \hat{y}_i)^2}{\sum_{i=1}^{n} (y_i - \bar{y})^2} = 1 - \frac{SS_{res}}{SS_{tot}}$$

* **Co dokładnie mierzy:** Proporcję wariancji (zmienności) zmiennej docelowej, która została wyjaśniona przez model w stosunku do prostego modelu odniesienia (linii średniej $\bar{y}$).
* **Kluczowe wartości do interpretacji:**
  * **$R^2 = 1.0$:** Predykcja idealna.
  * **$R^2 = 0.0$:** Model działa tak samo jak przewidywanie stale średniej wartości $\bar{y}$.
  * **$R^2 < 0.0$:** Model działa **gorzej** niż zwykła linia średniej (przypadek modelu Baseline MNK na teście: $R^2 = -0.040$).
* **Dlaczego $R^2$ spada na zbiorze testowym w tym projekcie?**
  * W strefie testowej dane są prawie płaskie ($SS_{tot}$ jest bardzo małe). Gdy całkowita wariancja danych dąży do zera, uzyskanie wysokiego $R^2$ staje się trudne, ponieważ nawet drobny szum w predykcji odpowiada za dużą część całkowitej zmienności.
  * Mimo to, uzyskanie przez LSTM $R^2 = 0.218$ (w porównaniu do $-0.040$ dla MNK) potwierdza, że sieć neuronowa zachowała zdolność do częściowego wychwytywania trendu nawet w trudnej strefie testowej.

---

## 4. Szablon Raportowania i Porównania Modelów

### Tabela Zbiorcza Wyników (Przykład do Rozdziału Wyników)

| Model | Zbiór | MAE [%] | RMSE [%] | $R^2$ [-] |
| :--- | :--- | :---: | :---: | :---: |
| **Baseline (MNK)** | Treningowy | 0.033 | 0.041 | 0.677 |
| | Testowy | 0.025 | 0.035 | -0.040 |
| **LSTM** | Treningowy | 0.021 | 0.030 | 0.827 |
| | Testowy | **0.018** | **0.030** | **0.218** |

### Przykład Komentarza do Wyników:
1. **Redukcja błędów bezwzględnych:** Model LSTM wykazał wyższą dokładność predykcyjną na zbiorze testowym, redukując średni błąd bezwzględny ($MAE$) z $0.025\%$ (Baseline) do $0.018\%$.
2. **Stabilność błędów skrajnych:** Wskaźnik $RMSE$ dla modelu LSTM na zbiorze testowym wyniósł $0.030\%$ (wobec $0.035\%$ dla Baseline), co świadczy o ograniczeniu występowania dużych błędów jednostkowych.
3. **Zdolność predykcyjna w nowym obszarze:** Model Baseline całkowicie utracił zdolność predykcyjną w strefie testowej ($R^2 = -0.040$), podczas gdy model LSTM utrzymał dodatni współczynnik determinacji ($R^2 = 0.218$), wykazując lepsze właściwości uogólniające (generalizację) w nowym obszarze geologicznym.