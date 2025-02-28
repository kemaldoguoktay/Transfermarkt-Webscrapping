# Transfermarkt Web Scraping

This R script is designed to scrape league standings tables from **Transfermarkt**, a popular football statistics website. It extracts relevant data, processes it, and merges it with league information for further analysis. The final output is saved as a CSV file for easy access and use.

## Features
- **Web Scraping**: Automatically retrieves league standings data from Transfermarkt for specified seasons (e.g., 2003-2023 or 2015-2024).
- **Data Processing**: Cleans and organizes the scraped data for analysis.
- **CSV Export**: Saves the processed data into a CSV file for easy sharing and further use.

## Usage
1. Ensure you have the required R packages installed: `dplyr`, `tidyverse`, `rvest`, `openxlsx`, and `purrr`.
2. Update the `comp_25.csv` file path in the script to match your local directory.
3. Specify the range of seasons you want to scrape (e.g., 2003-2023 or 2015-2025) in the script.
4. Run the script to scrape, process, and export the data.

## Output
The script generates a CSV file containing the merged league standings and additional league information.

## Requirements
- R (version 4.0 or higher)
- RStudio (recommended)
- Required R packages: `dplyr`, `tidyverse`, `rvest`, `openxlsx`, `purrr`

## Contributing
Contributions are welcome! If you have suggestions or improvements, please open an issue or submit a pull request.
