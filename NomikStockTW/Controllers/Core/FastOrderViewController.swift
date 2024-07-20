//
//  FastOrderViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit
import DGCharts
import Combine

class FastOrderViewController: UIViewController {
    
    // MARK: - Variables
    private let stockFetchDatasViewModels = StockFetchDatasViewModels()
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - UI Components
    private let fastOrderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let fastOrderSmallView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.orange.cgColor
        return view
    }()
    
    private let fastOrderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "台積電"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let fastOrderPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$1040.0"
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let fastOrderIncreasePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-300.50(-9.96%)"
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let lineChart: LineChartView = {
        let lineView = LineChartView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.animate(xAxisDuration: 2.5)
        
        lineView.rightAxis.enabled = false //關閉右邊標籤
        lineView.xAxis.enabled = false //關閉x軸標籤
        lineView.xAxis.labelCount = 280
        lineView.xAxis.granularity = 1
        lineView.xAxis.drawAxisLineEnabled = false
        lineView.xAxis.drawGridLinesEnabled = false //不繪製X軸網格線
        lineView.leftAxis.drawGridLinesEnabled = false //不繪製leftAxis網格線
        
        lineView.noDataText = "No data available" //沒有數據時預設字串
        lineView.pinchZoomEnabled = true //可以捏和縮放
        return lineView
    }()
    
    private let fastOrderUpListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("買入", for: .normal)
        return button
    }()
    
    private let fastOrderDownListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("賣出", for: .normal)
        return button
    }()
    
    private let fastOrderLeadingUpListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        return button
    }()
    
    private let fastOrderTrailingDownListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        return button
    }()
    
    private let fastOrderValueView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.masksToBounds = false
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.orange.cgColor
        return view
    }()
    
    private let inProgressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .green
        label.textAlignment = .left
        label.text = "內盤 253898.5 (45.60%)"
        return label
    }()
    
    private let outProgressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .red
        label.textAlignment = .right
        label.text = "外盤 303008.5 (55.40%)"
        return label
    }()
    
    private let inOutProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .systemRed
        progressView.progressTintColor = .systemGreen
        progressView.progress = 0.456
        return progressView
    }()
    
    private let fastOrderOTDCNameLabel: [UILabel] = ["開盤價", "最高價", "最低價"].map { title in
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.orange.cgColor
        return label
    }
    
    private lazy var fastOrderOTDCNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: fastOrderOTDCNameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let fastOrderOTDCPriceLabel: [UILabel] = ["----", "----", "----"].map { title in
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    private lazy var fastOrderOTDCPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: fastOrderOTDCPriceLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private let fastOrderAVVNameLabel: [UILabel] = ["成交量(張)", "均價", "成交值(萬)"].map { title in
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    private lazy var fastOrderAVVNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: fastOrderAVVNameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let fastOrderAVVDataLabel: [UILabel] = ["----", "----", "----"].map { title in
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    private lazy var fastOrderAVVDataStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: fastOrderAVVDataLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title == nil {
            title = "2330"
        }
        
        view.backgroundColor = .systemBackground
        view.addSubview(fastOrderView)
        fastOrderView.addSubview(fastOrderSmallView)
        fastOrderView.addSubview(fastOrderNameLabel)
        fastOrderSmallView.addSubview(fastOrderPriceLabel)
        fastOrderSmallView.addSubview(fastOrderIncreasePriceLabel)
        view.addSubview(lineChart)
        view.addSubview(fastOrderUpListButton)
        view.addSubview(fastOrderDownListButton)
        view.addSubview(fastOrderLeadingUpListButton)
        view.addSubview(fastOrderTrailingDownListButton)
        view.addSubview(fastOrderValueView)
        fastOrderValueView.addSubview(inProgressLabel)
        fastOrderValueView.addSubview(outProgressLabel)
        fastOrderValueView.addSubview(inOutProgressView)
        fastOrderValueView.addSubview(fastOrderOTDCNameStackView)
        fastOrderValueView.addSubview(fastOrderOTDCPriceStackView)
        fastOrderValueView.addSubview(fastOrderAVVNameStackView)
        fastOrderValueView.addSubview(fastOrderAVVDataStackView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(didAddTradeStock))
        
        setTapButton()
        configureUI()
        binView()
    }
    
    
    
    // MARK: - Functions
    private func binView(){
        
        guard let currentTitle = self.title else { return }
        stockFetchDatasViewModels.intradayQuoteFetchDatas(with: currentTitle)
        stockFetchDatasViewModels.$intradayQuoteDatas.sink { [weak self] quoteData in
            self?.fastOrderNameLabel.text = "\(quoteData?.name ?? "---")"
            self?.fastOrderPriceLabel.text = "\(quoteData?.closePrice ?? 0.0)"
            self?.fastOrderIncreasePriceLabel.text = "\(quoteData?.change ?? 0.0)(\(quoteData?.changePercent ?? 0.0))"
            
            let volumeAtTotel = (quoteData?.total.tradeVolumeAtBid ?? 0.0) + (quoteData?.total.tradeVolumeAtAsk ?? 0.0)
            let atBidPercent = (quoteData?.total.tradeVolumeAtBid ?? 0.0) / volumeAtTotel
            let atAskPercent = (quoteData?.total.tradeVolumeAtAsk ?? 0.0) / volumeAtTotel
            let atBidPercentFormat = String(format: "%.1f", (atBidPercent * 100))
            let atAskPercentFormat = String(format: "%.1f", (atAskPercent * 100))
            
            self?.inProgressLabel.text = "內盤 \(quoteData?.total.tradeVolumeAtBid ?? 0.0) (\(atBidPercentFormat))"
            self?.outProgressLabel.text = "外盤 \(quoteData?.total.tradeVolumeAtAsk ?? 0.0) (\(atAskPercentFormat))"
            
            //開盤價 最高價 最低價 StackView 子選項配置價格
            if let fastOrderOTDCPriceStackView = self?.fastOrderOTDCPriceStackView {
                for (index, oTDCPrice) in fastOrderOTDCPriceStackView.arrangedSubviews.enumerated() {
                    if let label = oTDCPrice as? UILabel {
                        switch index {
                        case 0:
                            label.text = "\(quoteData?.openPrice ?? 0.0)"
                        case 1:
                            label.text = "\(quoteData?.highPrice ?? 0.0)"
                        default:
                            label.text = "\(quoteData?.lowPrice ?? 0.0)"
                        }
                    }
                }
            }
            
            //成交量 均價 成交值 StackView 子選項配置
            if let fastOrderAVVDataStackView = self?.fastOrderAVVDataStackView {
                for (index, aVVData) in fastOrderAVVDataStackView.arrangedSubviews.enumerated() {
                    if let label = aVVData as? UILabel {
                        switch index {
                        case 0:
                            label.text = "\(quoteData?.total.tradeVolume ?? 0.0)"
                        case 1:
                            label.text = "\(quoteData?.avgPrice ?? 0.0)"
                        default:
                            label.text = "\((quoteData?.total.tradeValue ?? 0.0) / 10000)"
                        }
                    }
                }
            }
            
            self?.setLineData()
        }
        .store(in: &cancellables)
    }
    
    
    private func setLineData() {
        
        var entrieDatas: [ChartDataEntry] = []
        var avgDatas: [ChartDataEntry] = []
        
        //清空舊的數據
        self.lineChart.data = nil
        self.lineChart.leftAxis.removeAllLimitLines()
        
        guard let currentTitle = self.title else { return }
        stockFetchDatasViewModels.intradayCandlesFetchDatas(with: currentTitle, timeframe: "1")
        stockFetchDatasViewModels.$intradayCandlesDatas.sink { [weak self] candlesDatas in
            
            //重要 清除[]的數據
            entrieDatas.removeAll()
            avgDatas.removeAll()
            
            if let candlesDatas = candlesDatas?.data {
                for (index, candles) in candlesDatas.enumerated() {
                    entrieDatas.append(ChartDataEntry(x: Double(index), y: candles.close))
                    avgDatas.append(ChartDataEntry(x: Double(index), y: candles.average))
                }
                
            }
            
            let set1 = LineChartDataSet(entries: entrieDatas, label: self?.fastOrderNameLabel.text ?? "台積電")
            set1.mode = .cubicBezier
            set1.drawCirclesEnabled = false //關閉線圖上的標籤圓點
            set1.drawValuesEnabled = false //關閉線圖上的標籤價格
            set1.colors = [.red]
            set1.lineWidth = 2
            
            let set2 = LineChartDataSet(entries: avgDatas, label: "均價")
            set2.mode = .cubicBezier
            set2.drawCirclesEnabled = false //關閉線圖上的標籤圓點
            set2.drawValuesEnabled = false //關閉線圖上的標籤價格
            set2.colors = [.white]
            set2.lineWidth = 1
            
            
            let data = LineChartData(dataSets: [set1, set2])
            
            if let candlesDatas = candlesDatas?.data {
                let limitLine = ChartLimitLine(limit: candlesDatas[0].open, label: "開盤價\(candlesDatas[0].open)")
                limitLine.lineWidth = 1
                limitLine.lineColor = .systemYellow
                self?.lineChart.leftAxis.addLimitLine(limitLine)
            }
            
            DispatchQueue.main.async {
                self?.lineChart.clear() //清除圖
                self?.lineChart.data = data
                self?.lineChart.notifyDataSetChanged()
                self?.lineChart.setNeedsDisplay()
            }
        }
        .store(in: &cancellables)
    }
    
    //修改交易商品的視窗
    private func setAlert() {
        let alert = UIAlertController(title: "交易股票", message: "請輸入股票的編號", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "ex: 2330"
        }
                
        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            if let text = alert.textFields?.first?.text {
                self.title = text
                self.binView()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showBuySellHalf(_ buyAndSell: String){
        let halfVC = buySellHalfViewController(title: buyAndSell)
        
        if let sheet = halfVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(halfVC, animated: true, completion: nil)
    }
    private func setTapButton(){
        fastOrderLeadingUpListButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        fastOrderTrailingDownListButton.addTarget(self, action: #selector(didTapSell), for: .touchUpInside)
        fastOrderUpListButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        fastOrderDownListButton.addTarget(self, action: #selector(didTapSell), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc private func didTapBuy(){
        showBuySellHalf("BUY")
    }
    
    @objc private func didTapSell(){
        showBuySellHalf("SELL")
    }
    
    @objc private func didAddTradeStock(){
        setAlert()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        NSLayoutConstraint.activate([
            fastOrderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fastOrderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            fastOrderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            fastOrderView.heightAnchor.constraint(equalToConstant: 75),
            
            fastOrderNameLabel.topAnchor.constraint(equalTo: fastOrderView.topAnchor),
            fastOrderNameLabel.leadingAnchor.constraint(equalTo: fastOrderView.leadingAnchor, constant: 5),
            fastOrderNameLabel.trailingAnchor.constraint(equalTo: fastOrderSmallView.leadingAnchor),
            fastOrderNameLabel.bottomAnchor.constraint(equalTo: fastOrderView.bottomAnchor),
            
            fastOrderSmallView.topAnchor.constraint(equalTo: fastOrderView.topAnchor),
            fastOrderSmallView.trailingAnchor.constraint(equalTo: fastOrderView.trailingAnchor),
            fastOrderSmallView.bottomAnchor.constraint(equalTo: fastOrderView.bottomAnchor),
            fastOrderSmallView.widthAnchor.constraint(equalToConstant: 150),
            
            fastOrderPriceLabel.topAnchor.constraint(equalTo: fastOrderSmallView.topAnchor, constant: 12),
            fastOrderPriceLabel.leadingAnchor.constraint(equalTo: fastOrderSmallView.leadingAnchor),
            fastOrderPriceLabel.trailingAnchor.constraint(equalTo: fastOrderSmallView.trailingAnchor, constant: -15),
            fastOrderPriceLabel.heightAnchor.constraint(equalToConstant: 25),
            
            fastOrderIncreasePriceLabel.topAnchor.constraint(equalTo: fastOrderPriceLabel.bottomAnchor),
            fastOrderIncreasePriceLabel.leadingAnchor.constraint(equalTo: fastOrderPriceLabel.leadingAnchor),
            fastOrderIncreasePriceLabel.trailingAnchor.constraint(equalTo: fastOrderPriceLabel.trailingAnchor),
            fastOrderIncreasePriceLabel.bottomAnchor.constraint(equalTo: fastOrderSmallView.bottomAnchor),
            
            lineChart.topAnchor.constraint(equalTo: fastOrderView.bottomAnchor),
            lineChart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChart.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            fastOrderUpListButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            fastOrderUpListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fastOrderUpListButton.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            fastOrderUpListButton.heightAnchor.constraint(equalToConstant: 50),
            
            fastOrderDownListButton.bottomAnchor.constraint(equalTo: fastOrderUpListButton.bottomAnchor),
            fastOrderDownListButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            fastOrderDownListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fastOrderDownListButton.heightAnchor.constraint(equalToConstant: 50),
            
            fastOrderLeadingUpListButton.topAnchor.constraint(equalTo: lineChart.bottomAnchor),
            fastOrderLeadingUpListButton.bottomAnchor.constraint(equalTo: fastOrderUpListButton.topAnchor),
            fastOrderLeadingUpListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fastOrderLeadingUpListButton.widthAnchor.constraint(equalToConstant: 25),
            
            fastOrderTrailingDownListButton.topAnchor.constraint(equalTo: lineChart.bottomAnchor),
            fastOrderTrailingDownListButton.bottomAnchor.constraint(equalTo: fastOrderUpListButton.topAnchor),
            fastOrderTrailingDownListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fastOrderTrailingDownListButton.widthAnchor.constraint(equalToConstant: 25),
            
            fastOrderValueView.topAnchor.constraint(equalTo: lineChart.bottomAnchor, constant: 2),
            fastOrderValueView.leadingAnchor.constraint(equalTo: fastOrderLeadingUpListButton.trailingAnchor, constant: 2),
            fastOrderValueView.trailingAnchor.constraint(equalTo: fastOrderTrailingDownListButton.leadingAnchor, constant: -2),
            fastOrderValueView.bottomAnchor.constraint(equalTo: fastOrderUpListButton.topAnchor, constant: -2),
            
            inProgressLabel.topAnchor.constraint(equalTo: fastOrderValueView.topAnchor, constant: 20),
            inProgressLabel.leadingAnchor.constraint(equalTo: fastOrderValueView.leadingAnchor, constant: 10),
            inProgressLabel.trailingAnchor.constraint(equalTo: fastOrderValueView.centerXAnchor),
            
            outProgressLabel.topAnchor.constraint(equalTo: inProgressLabel.topAnchor),
            outProgressLabel.leadingAnchor.constraint(equalTo: fastOrderValueView.centerXAnchor),
            outProgressLabel.trailingAnchor.constraint(equalTo: fastOrderValueView.trailingAnchor, constant: -10),
            
            inOutProgressView.topAnchor.constraint(equalTo: inProgressLabel.bottomAnchor, constant: 10),
            inOutProgressView.leadingAnchor.constraint(equalTo: fastOrderValueView.leadingAnchor, constant: 10),
            inOutProgressView.trailingAnchor.constraint(equalTo: fastOrderValueView.trailingAnchor, constant: -10),
            inOutProgressView.heightAnchor.constraint(equalToConstant: 20),
            
            fastOrderOTDCNameStackView.topAnchor.constraint(equalTo: inOutProgressView.bottomAnchor, constant: 30),
            fastOrderOTDCNameStackView.leadingAnchor.constraint(equalTo: inOutProgressView.leadingAnchor, constant: 2),
            fastOrderOTDCNameStackView.trailingAnchor.constraint(equalTo: inOutProgressView.trailingAnchor, constant: -2),
            
            fastOrderOTDCPriceStackView.topAnchor.constraint(equalTo: fastOrderOTDCNameStackView.bottomAnchor, constant: 10),
            fastOrderOTDCPriceStackView.leadingAnchor.constraint(equalTo: fastOrderOTDCNameStackView.leadingAnchor),
            fastOrderOTDCPriceStackView.trailingAnchor.constraint(equalTo: fastOrderOTDCNameStackView.trailingAnchor),
            
            fastOrderAVVNameStackView.topAnchor.constraint(equalTo: fastOrderOTDCPriceStackView.bottomAnchor, constant: 30),
            fastOrderAVVNameStackView.leadingAnchor.constraint(equalTo: fastOrderOTDCPriceStackView.leadingAnchor),
            fastOrderAVVNameStackView.trailingAnchor.constraint(equalTo: fastOrderOTDCPriceStackView.trailingAnchor),
            
            fastOrderAVVDataStackView.topAnchor.constraint(equalTo: fastOrderAVVNameStackView.bottomAnchor, constant: 10),
            fastOrderAVVDataStackView.leadingAnchor.constraint(equalTo: fastOrderAVVNameStackView.leadingAnchor),
            fastOrderAVVDataStackView.trailingAnchor.constraint(equalTo: fastOrderAVVNameStackView.trailingAnchor),
        ])
        
    }
}

// MARK: - Extension
