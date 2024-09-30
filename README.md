# EA_Crossover-Navigator

## Download Link
You can download the compiled EA from the following link:
- [Download Crossover Navigator EA](https://github.com/syarief02/EA_Crossover-Navigator/raw/refs/heads/main/ma50.ex4)

## Overview
The **Crossover Navigator** is an Expert Advisor (EA) designed for trading in MetaTrader 4 using a 50-period moving average (MA50) crossover strategy. This EA aims to identify potential buy and sell opportunities based on the relationship between the current price and the MA50.

## Features
- **MA50 Crossover Strategy**: The EA opens buy orders when the price crosses above the MA50 and sell orders when the price crosses below the MA50.
- **Customizable Parameters**: Users can adjust key parameters such as lot size, take profit, stop loss, and the moving average period.
- **Real-time Chart Comments**: The EA displays real-time information on the chart, including the current MA50 value, lot size, take profit, stop loss, date, and time.

## Input Parameters
- **MA_Period**: The period for the moving average (default is 50).
- **LotSize**: The size of each trade (default is 0.1).
- **Slippage**: The maximum slippage allowed when placing orders (default is 3).
- **TakeProfitPips**: The take profit level in pips (default is 4).
- **StopLossPips**: The stop loss level in pips (default is 30).

## How It Works
1. **Initialization**: When the EA is initialized, it sets up the chart comment with relevant information about the EA and its parameters.
2. **OnTick Event**: The EA continuously monitors market ticks:
   - It calculates the current MA50 value.
   - It checks for buy conditions: If the previous candle closed below the MA50 and the current candle closes above it, a buy order is placed.
   - It checks for sell conditions: If the previous candle closed above the MA50 and the current candle closes below it, a sell order is placed.
3. **Chart Comment Update**: The EA updates the chart comment with the current MA50 value, lot size, take profit, stop loss, date, and time on each tick.

## Usage Instructions
1. **Installation**: Copy the `ma50.mq4` file into the `Experts` directory of your MetaTrader 4 installation.
2. **Compile**: Open the MetaEditor, load the `ma50.mq4` file, and compile it.
3. **Attach to Chart**: Open a chart for the desired currency pair and timeframe (recommended: M5) and attach the EA.
4. **Configure Settings**: Adjust the input parameters as needed in the EA settings.
5. **Start Trading**: Enable automated trading in MetaTrader 4 to allow the EA to execute trades based on the defined strategy.

## Contact Information
For support or inquiries, please contact:
- **Author**: Budak Ubat
- **Telegram**: [t.me/EABudakUbat](https://t.me/EABudakUbat)
- **WhatsApp**: +60194961568

## Disclaimer
Trading in financial markets involves risk. This EA is provided for educational purposes only. Users should conduct their own research and consider their financial situation before trading.
