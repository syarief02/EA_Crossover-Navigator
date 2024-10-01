// File: MA50_Crossover_EA.mq4
// Author: Budak Ubat
// Description: This EA implements a MA50 crossover strategy for trading in MetaTrader 4.
// Recommended timeframe: M5, choose ranging pair.
// Join our Telegram channel: t.me/EABudakUbat
// Contact: +60194961568 (Budak Ubat)
#define VERSION "1.00" // Define the version of the EA
#property version VERSION // Set the version property for the EA
#property link "https://m.me/EABudakUbat" // Link to the author's contact
#property description "This is EA_Crossover-Navigator" // Description of the EA
#property description "Recommended timeframe M5, choose ranging pair." // Additional description
#property description "Recommended using a cent account for 100 USD capital" // Additional description
#property description "Join our Telegram channel: t.me/EABudakUbat" // Additional description
#property description "Facebook: m.me/EABudakUbat" // Additional description
#property description "+60194961568 (Budak Ubat)" // Additional description
#property icon "\\Images\\bupurple.ico" // Path to the EA icon
#property strict // Enable strict compilation mode

#include <WinUser32.mqh> // Include Windows User32 library for Windows-specific functions
#include <stdlib.mqh> // Include standard library for general functions

#define COPYRIGHT "Copyright © 2024, BuBat's Trading" // Define copyright information
#property copyright COPYRIGHT // Set the copyright property for the EA

// Input parameters
input int MA_Period = 50;          // Moving Average period (default is 50)
input double LotSize = 0.1;         // Lot size for trades (default is 0.1)
input int Slippage = 3;             // Maximum slippage allowed when placing orders (default is 3)
input double TakeProfitPips = 4.0;  // Take Profit level in pips (default is 4.0)
input double StopLossPips = 30.0;   // Stop Loss level in pips (default is 30.0)

// Global variables
double MA_Value; // Variable to store the current value of the moving average

// Expert information
#define EXPERT_NAME "[https://t.me/SyariefAzman] " // Define the expert name
extern string EA_Name = EXPERT_NAME; // EA name for display purposes
string Owner = "BUDAK UBAT";         // Owner's name for display purposes
string Contact = "WHATSAPP/TELEGRAM: +60194961568"; // Contact information for support

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit() {
    UpdateChartComment(); // Call function to initialize and display the chart comment
    return INIT_SUCCEEDED; // Return success status for initialization
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    Comment(""); // Clear the chart comment when the EA is removed or deinitialized
}

//+------------------------------------------------------------------+
//| Expert tick function                                             | 
//+------------------------------------------------------------------+
void OnTick() {
    // Calculate the current value of the 50-period moving average
    MA_Value = iMA(NULL, 0, MA_Period, 0, MODE_SMA, PRICE_CLOSE, 0); 

    // Check for buy conditions and open a buy order if conditions are met
    if (ShouldOpenBuy()) {
        OpenOrder(OP_BUY); // Call function to open a buy order
    }

    // Check for sell conditions and open a sell order if conditions are met
    if (ShouldOpenSell()) {
        OpenOrder(OP_SELL); // Call function to open a sell order
    }

    UpdateChartComment(); // Update the chart comment with current information
}

//+------------------------------------------------------------------+
//| Check if conditions are met to open a buy order                  |
//+------------------------------------------------------------------+
bool ShouldOpenBuy() {
    // Return true if the previous candle closed below the MA and the current candle closes above it
    return Close[1] < MA_Value && Close[0] > MA_Value && (OrdersTotal() == 0 || !IsOrderType(OP_BUY));
}

//+------------------------------------------------------------------+
//| Check if conditions are met to open a sell order                 |
//+------------------------------------------------------------------+
bool ShouldOpenSell() {
    // Return true if the previous candle closed above the MA and the current candle closes below it
    return Close[1] > MA_Value && Close[0] < MA_Value && (OrdersTotal() == 0 || !IsOrderType(OP_SELL));
}

//+------------------------------------------------------------------+
//| Open an order (buy or sell) based on order type                  |
//+------------------------------------------------------------------+
void OpenOrder(int orderType) {
    double tp, sl; // Variables to hold the calculated take profit and stop loss levels
    double lotSize = LotSize; // Use the input lot size

    // Validate the lot size before placing the order
    if (!IsValidLotSize(lotSize)) {
        Print("Invalid lot size: ", lotSize);
        return; // Exit the function if the lot size is invalid
    }

    if (orderType == OP_BUY) { // Check if the order type is buy
        tp = Ask + TakeProfitPips * Point; // Calculate Take Profit for buy order
        sl = Ask - StopLossPips * Point;    // Calculate Stop Loss for buy order
        // Send the buy order
        if (OrderSend(Symbol(), OP_BUY, lotSize, Ask, Slippage, sl, tp, "Buy Order", 0, 0, clrGreen) < 0) {
            Print("Error opening buy order: ", GetLastError()); // Print error if order fails
        }
    } else if (orderType == OP_SELL) { // Check if the order type is sell
        tp = Bid - TakeProfitPips * Point; // Calculate Take Profit for sell order
        sl = Bid + StopLossPips * Point;    // Calculate Stop Loss for sell order
        // Send the sell order
        if (OrderSend(Symbol(), OP_SELL, lotSize, Bid, Slippage, sl, tp, "Sell Order", 0, 0, clrRed) < 0) {
            Print("Error opening sell order: ", GetLastError()); // Print error if order fails
        }
    }
}

//+------------------------------------------------------------------+
//| Update chart comment                                             |
//+------------------------------------------------------------------+
void UpdateChartComment() {
    // Create a formatted string for the chart comment
    string comment = StringFormat(
        "MA50 Crossover EA\n" // Title of the EA
        "Author: %s\n" // Author's name
        "Owner: %s\n" // Owner's name
        "Contact: %s\n" // Contact information
        "Current MA50: %.5f\n" // Current MA50 value
        "Lot Size: %.2f\n" // Current lot size
        "Take Profit: %.2f pips\n" // Current take profit in pips
        "Stop Loss: %.2f pips\n" // Current stop loss in pips
        "Date: %s\n" // Current date
        "Time: %s\n", // Current time
        "Budak Ubat", Owner, Contact, MA_Value, LotSize, TakeProfitPips, StopLossPips,
        TimeToString(TimeCurrent(), TIME_DATE), // Get current date
        TimeToString(TimeCurrent(), TIME_MINUTES) // Get current time
    );
    Comment(comment); // Display the prepared comment on the chart
}

//+------------------------------------------------------------------+
//| Check if there is an open order of a specific type               |
//+------------------------------------------------------------------+
bool IsOrderType(int orderType) {
    // Loop through all open orders
    for (int i = 0; i < OrdersTotal(); i++) {
        // Select the order by position and check its type
        if (OrderSelect(i, SELECT_BY_POS) && OrderType() == orderType) {
            return true; // Return true if an order of the specified type is found
        }
    }
    return false; // Return false if no such order is found
}

//+------------------------------------------------------------------+
//| Function to check if the lot size is valid                       |
//+------------------------------------------------------------------+
bool IsValidLotSize(double lotSize) {
    double minLot = MarketInfo(Symbol(), MODE_MINLOT); // Minimum lot size
    double maxLot = MarketInfo(Symbol(), MODE_MAXLOT); // Maximum lot size
    double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP); // Lot size step

    // Check if the lot size is within the allowed range and is a multiple of the lot step
    if (lotSize < minLot || lotSize > maxLot) {
        Print("Invalid lot size: ", lotSize, ". Must be between ", minLot, " and ", maxLot);
        return false;
    }
    // if (MathMod(lotSize, lotStep) != 0) {
    //     Print("Invalid lot size: ", lotSize, ". Must be a multiple of ", lotStep);
    //     return false;
    // }
    return true; // Lot size is valid
}