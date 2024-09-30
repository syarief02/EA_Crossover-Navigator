// File: MA50_Crossover_EA.mq4
// Author: Budak Ubat
// Description: This EA implements a MA50 crossover strategy for trading in MetaTrader 4.
// Recommended timeframe: M5, choose ranging pair.
// Join our Telegram channel: t.me/EABudakUbat
// Contact: +60194961568 (Budak Ubat)

// Input parameters
input int MA_Period = 50; // Moving Average period
input double LotSize = 0.1; // Lot size for trades
input double Slippage = 3; // Slippage for orders
input double TakeProfitPips = 4; // Take Profit in pips
input double StopLossPips = 30; // Stop Loss in pips

// Global variables
double MA_Value;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit() {
    // Initialize chart comment
    UpdateChartComment(); // Call to set the initial chart comment

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    // Clear chart comment on deinitialization
    Comment("");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             | 
//+------------------------------------------------------------------+
void OnTick() {
    // Calculate the MA50 value
    MA_Value = iMA(NULL, 0, MA_Period, 0, MODE_SMA, PRICE_CLOSE, 0);

    // Check for buy conditions
    if (Close[1] < MA_Value && Close[0] > MA_Value) {
        // Buy only if no open buy orders
        if (OrdersTotal() == 0 || !IsOrderType(OP_BUY)) {
            double tp_buy = Ask + TakeProfitPips * Point; // Calculate TP for buy
            double sl_buy = Ask - StopLossPips * Point;   // Calculate SL for buy
            if (OrderSend(Symbol(), OP_BUY, LotSize, Ask, Slippage, sl_buy, tp_buy, "Buy Order", 0, 0, clrGreen) < 0) {
                Print("Error opening buy order: ", GetLastError());
            }
        }
    }

    // Check for sell conditions
    if (Close[1] > MA_Value && Close[0] < MA_Value) {
        // Sell only if no open sell orders
        if (OrdersTotal() == 0 || !IsOrderType(OP_SELL)) {
            double tp_sell = Bid - TakeProfitPips * Point; // Calculate TP for sell
            double sl_sell = Bid + StopLossPips * Point;   // Calculate SL for sell
            if (OrderSend(Symbol(), OP_SELL, LotSize, Bid, Slippage, sl_sell, tp_sell, "Sell Order", 0, 0, clrRed) < 0) {
                Print("Error opening sell order: ", GetLastError());
            }
        }
    }

    // Update chart comment
    UpdateChartComment();
}

//+------------------------------------------------------------------+
//| Update chart comment                                             |
//+------------------------------------------------------------------+
void UpdateChartComment() {
    string comment = StringFormat(
        "MA50 Crossover EA\n"
        "Author: Budak Ubat\n"
        "Current MA50: %.5f\n"
        "Lot Size: %.2f\n"
        "Take Profit: %.2f pips\n"
        "Stop Loss: %.2f pips\n"
        "Date: %s\n"
        "Time: %s\n",
        MA_Value, LotSize, TakeProfitPips, StopLossPips,
        TimeToString(TimeCurrent(), TIME_DATE), // Current date
        TimeToString(TimeCurrent(), TIME_MINUTES) // Current time
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
