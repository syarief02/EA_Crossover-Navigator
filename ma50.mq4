// File: MA50_Crossover_EA.mq4
// Author: Budak Ubat
// Description: This EA implements a MA50 crossover strategy for trading in MetaTrader 4.
// Recommended timeframe: M5, choose ranging pair.
// Join our Telegram channel: t.me/EABudakUbat
// Contact: +60194961568 (Budak Ubat)
#define VERSION "1.00"
#property version VERSION
#property link "https://m.me/EABudakUbat"
#property description "This is EA_Crossover-Navigator"
#property description "Recommended timeframe M5, choose ranging pair."
#property description "Recommended using a cent account for 100 USD capital"
#property description "Join our Telegram channel: t.me/EABudakUbat"
#property description "Facebook: m.me/EABudakUbat"
#property description "+60194961568 (Budak Ubat)"
#property icon "\\Images\\bupurple.ico"
#property strict

#include <WinUser32.mqh>
#include <stdlib.mqh>

#define COPYRIGHT "Copyright © 2024, BuBat's Trading"
#property copyright COPYRIGHT

// Input parameters
input int MA_Period = 50;          // Moving Average period
input double LotSize = 0.1;         // Lot size for trades
input int Slippage = 3;             // Slippage for orders
input double TakeProfitPips = 4.0;  // Take Profit in pips
input double StopLossPips = 30.0;   // Stop Loss in pips

// Global variables
double MA_Value;

// Expert information
#define EXPERT_NAME "[https://t.me/SyariefAzman] "
extern string EA_Name = EXPERT_NAME; // EA name
string Owner = "BUDAK UBAT";         // Owner's name
string Contact = "WHATSAPP/TELEGRAM: +60194961568"; // Contact information

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit() {
    UpdateChartComment(); // Initialize chart comment
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    Comment(""); // Clear chart comment on deinitialization
}

//+------------------------------------------------------------------+
//| Expert tick function                                             | 
//+------------------------------------------------------------------+
void OnTick() {
    MA_Value = iMA(NULL, 0, MA_Period, 0, MODE_SMA, PRICE_CLOSE, 0); // Calculate the MA50 value

    // Check for buy conditions and open buy order if conditions are met
    if (ShouldOpenBuy()) {
        OpenOrder(OP_BUY);
    }

    // Check for sell conditions and open sell order if conditions are met
    if (ShouldOpenSell()) {
        OpenOrder(OP_SELL);
    }

    UpdateChartComment(); // Update chart comment
}

//+------------------------------------------------------------------+
//| Check if conditions are met to open a buy order                  |
//+------------------------------------------------------------------+
bool ShouldOpenBuy() {
    return Close[1] < MA_Value && Close[0] > MA_Value && (OrdersTotal() == 0 || !IsOrderType(OP_BUY));
}

//+------------------------------------------------------------------+
//| Check if conditions are met to open a sell order                 |
//+------------------------------------------------------------------+
bool ShouldOpenSell() {
    return Close[1] > MA_Value && Close[0] < MA_Value && (OrdersTotal() == 0 || !IsOrderType(OP_SELL));
}

//+------------------------------------------------------------------+
//| Open an order (buy or sell) based on order type                  |
//+------------------------------------------------------------------+
void OpenOrder(int orderType) {
    double tp, sl;
    if (orderType == OP_BUY) {
        tp = Ask + TakeProfitPips * Point; // Calculate Take Profit for buy
        sl = Ask - StopLossPips * Point;    // Calculate Stop Loss for buy
        if (OrderSend(Symbol(), OP_BUY, LotSize, Ask, Slippage, sl, tp, "Buy Order", 0, 0, clrGreen) < 0) {
            Print("Error opening buy order: ", GetLastError());
        }
    } else if (orderType == OP_SELL) {
        tp = Bid - TakeProfitPips * Point; // Calculate Take Profit for sell
        sl = Bid + StopLossPips * Point;    // Calculate Stop Loss for sell
        if (OrderSend(Symbol(), OP_SELL, LotSize, Bid, Slippage, sl, tp, "Sell Order", 0, 0, clrRed) < 0) {
            Print("Error opening sell order: ", GetLastError());
        }
    }
}

//+------------------------------------------------------------------+
//| Update chart comment                                             |
//+------------------------------------------------------------------+
void UpdateChartComment() {
    string comment = StringFormat(
        "MA50 Crossover EA\n"
        "Author: %s\n"
        "Owner: %s\n"
        "Contact: %s\n"
        "Current MA50: %.5f\n"
        "Lot Size: %.2f\n"
        "Take Profit: %.2f pips\n"
        "Stop Loss: %.2f pips\n"
        "Date: %s\n"
        "Time: %s\n",
        "Budak Ubat", Owner, Contact, MA_Value, LotSize, TakeProfitPips, StopLossPips,
        TimeToString(TimeCurrent(), TIME_DATE),
        TimeToString(TimeCurrent(), TIME_MINUTES)
    );
    Comment(comment); // Display the prepared comment on the chart
}

//+------------------------------------------------------------------+
//| Check if there is an open order of a specific type               |
//+------------------------------------------------------------------+
bool IsOrderType(int orderType) {
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS) && OrderType() == orderType) {
            return true;
        }
    }
    return false;
}