# Data Analysis Projects

## *Polish:*

W tym repozytorium zebrałem projekty przygotowane po ukończeniu studiów, w których prezentuje umiejętoności analizy danych. Znaleźć można w nim poniższe projekty:

### DrinksCorp_Sales 
- Celem projektu jest analiza sprzedaży w DrinksCorp, wykorzystując tabele oraz wykresy przestawne i zapytania SQL.
- Dane zostały wygenerowane częsciowo losowo w MS Excel przy użyciu funkcji LOS() i NORM.DIST(), a także zdefiniowanych przez użytkownika wartości zmiennych. Nazwy osób, produktów, klientów i adresów są zmyślone. Dane zostały podzielone na osobne, powiązane ze sobą tabele z unikalnymi ID. Ich generowanie można zaobserwować w pliku z końcówką „Generation” w nazwie.
- Tabele zostały załadowane do modelu danych w Power Pivot, gdzie utworzone zostały między nimi relacje. Na podstawie modelu stworzono tabele przestawne i wykresy prezentujące wyniki w postaci wskaźników KPI, sprzedaży przedstawicieli handlowych lub produktów, analizy cen i wglądu w wyniki bieżącego miesiąca.
- Dane zostały również załadowane na serwer MySQL i napisane zostało kilka zapytań, aby uzyskać informacje o podstawowych statystykach sprzedaży, przychodach, kosztach, zyskach dla miesięcy, klientów, przedstawicieli handlowych i produktów.

### Environmental Performance Indicators 2022
- Projekt ten miał na celu sprawdzenie stanu środowiska w różnych dziedzinach, krajach i latach.
- Dane zostały pobrane z zasobów NASA (https://www.earthdata.nasa.gov/data/catalog/sedac-ciesin-sedac-epi-2022-2022.00). Zostały one załadowane, a następnie przetworzone w Power BI, a na koniec utworzono model danych.
- Raport zawiera stronę główną i cztery wybrane strony tematyczne (Jakość powietrza, Zmiany klimatu, Ekosystemy, Zanieczyszczenia)
- Użyte narzędzia: wykresy, macierze, mapa, karty, KPI, fragmentatory, zakładki, etykiety, drążenie wskroś i niestandardowe miary (DAX).



## *English:*

In this repository, I've gathered post-grad projects in which I present my skills in the data analysis field. There are the following projects:

### DrinksCorp_Sales 
- This project aimed to analyze DrinksCorp sales using pivot tables, charts and SQL queries.
- Data was generated semi-randomly in MS Excel using RAND() and NORM.DIST() functions, as well as user-defined values of variables. Names of people, products, customers and addresses were made up. Data was divided into separate related tables with unique IDs. The generation may be observed in the file with the "Generation" suffix in name.
- Tables have been loaded into the data model in Power Pivot, and relations have been established. Based on the model, pivot tables and charts were created to present the results in the form of KPIs, sales of representatives or products, pricing analysis and the current month's insights.
- Data was also loaded into MySQL server, and several queries were writtien to get information about basic sales statistics, revenues, costs, profits for months, customers, sales representatives and products.
  
### Environmental Performance Indicators 2022
- This project aimed to check the condition of the environment in different categories, countries and years.
- Data was downloaded from NASA's resources (https://www.earthdata.nasa.gov/data/catalog/sedac-ciesin-sedac-epi-2022-2022.00). It has been loaded then processed in Power BI, and finally a data model was created.
- Raport contains one hub and four selected topic pages (Air Quality, Climate Change, Ecosystems, Impurities)
- Used tools: charts, matrices, map, cards, KPIs, slicers, bookmarks, tooltips, drillthrough and custom measures (DAX).
