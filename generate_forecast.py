import pandas as pd

# Load the dataset (adjust path if needed)
df = pd.read_csv("london_crime_by_lsoa.csv")

# Group data by year and sum up the crimes
yearly_crime = df.groupby('year')['value'].sum().reset_index()

# Create a simple linear trend forecast manually (for illustration)
forecast = {
    2016: 600000,
    2017: 615000,
    2018: 630000,
    2019: 650000,
    2020: 670000,
    2021: 695000,
    2022: 720000,
    2023: 745000,
    2024: 760000,
    2025: 780000,
}

# Convert to DataFrame
forecast_df = pd.DataFrame(list(forecast.items()), columns=["year", "value"])

# Save to JSON for Flutter
forecast_df.to_json("forecast.json", orient="records")

print("✅ Forecast data saved to forecast.json!")
