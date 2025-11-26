# 🏠 Airbnb Listing Success Prediction (London)

## 📌 Overview
This project applies data science techniques to analyze London Airbnb listings and predict their financial success. Using **R**, I developed a classification model to distinguish between high-performing ("Good") and low-performing ("Bad") listings based on revenue potential.

## 🎯 Objective
To assist hosts in optimizing their listings by identifying the key structural and amenity-based features that drive revenue, rather than relying solely on occupancy or price.

## 🛠️ Methodology
* **Data Cleaning:** Processed raw data (88,000+ listings), removing leakage variables (`price`, `reviews`) and creating leakage-free structural predictors.
* **Feature Engineering:** created `amenities_count`, `property_simple`, and `estimated_revenue`.
* **Modeling Strategy:** Implemented and compared two algorithms:
    1.  **Logistic Regression** (Baseline) - Accuracy: ~69.9%
    2.  **Decision Tree** (Champion) - Accuracy: **81.67%**

## 📊 Key Findings
The Decision Tree model revealed critical insights for hosts:
* **Amenities:** Listings with **>20 amenities** are statistically classified as "Good" successes.
* **Room Type:** "Entire Home/Apt" listings carry a significant privacy premium over private rooms.
* **Ratings:** A review score below **4.5** acts as a hard filter for failure.

## 📂 Project Structure
* `Airbnb_Analysis.R`: The complete R code for data cleaning, visualization, and modeling.
* `CST4070_CW1_Report.pdf`: The detailed academic report explaining the business logic and results.

## 🚀 How to Run
1.  Clone this repository.
2.  Download the **London** `listings.csv` file from [InsideAirbnb](http://insideairbnb.com/get-the-data/).
3.  Place the CSV in your project folder.
4.  Run `Airbnb_Analysis.R` in RStudio.

---
*Author: Faraz Ahmed*
