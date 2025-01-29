from flask import Flask, jsonify
import numpy as np
import pandas as pd
from tensorflow.keras.models import load_model
from sklearn.preprocessing import MinMaxScaler
import yfinance as yf
from datetime import datetime, timedelta
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the trained model
model = load_model('my_model.keras')
scaler = MinMaxScaler(feature_range=(0, 1))

@app.route('/predict/<symbol>', methods=['GET'])
def predict_stock(symbol):
    try:
        # Get the last 100 days of data
        end_date = datetime.now()
        start_date = end_date - timedelta(days=150)
        
        # Download stock data
        df = yf.download(symbol, start=start_date, end=end_date)
        df = df[['Close']].reset_index()
        
        # Prepare the data
        data = df['Close'].values.reshape(-1, 1)
        data_scaled = scaler.fit_transform(data)
        
        # Create the input sequence
        x_input = data_scaled[-100:].reshape(1, 100, 1)
        
        # Make prediction
        prediction_scaled = model.predict(x_input)
        prediction = scaler.inverse_transform(prediction_scaled)
        
        # Get the last 30 actual values for comparison
        actual_prices = df['Close'].values.tolist()[-30:]
        dates = df['Date'].dt.strftime('%Y-%m-%d').values.tolist()[-30:]
        
        return jsonify({
            'symbol': symbol,
            'prediction': float(prediction[0][0]),
            'historical_data': {
                'dates': dates,
                'prices': actual_prices
            }
        })
        
    except Exception as e:
        print(f"Error processing request: {e}")  # Server-side debugging
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Run the server on all network interfaces
    app.run(host='0.0.0.0', debug=True, port=5000)