//  Components.swift
//  Created by Vino_Swify on 25/08/25.
import SwiftUI

public struct WeatherIcon: View {
    let system: String; let size: CGFloat
    public init(system: String, size: CGFloat) { self.system = system; self.size = size }
    public var body: some View {
        Image(systemName: system)
            .resizable().scaledToFit()
            .frame(width: size, height: size)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(AppColors.accent)
    }
}

public struct Tag: View {
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text)
            .font(AppTypography.caption)
            .padding(.horizontal, Spacing.sm).padding(.vertical, 4)
            .background(AppColors.accent.opacity(0.15))
            .foregroundColor(AppColors.accent)
            .clipShape(Capsule())
    }
}

public struct LabeledStat: View {
    let icon: String, label: String, value: String
    public init(icon: String, label: String, value: String) { self.icon = icon; self.label = label; self.value = value }
    public var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon).imageScale(.medium).foregroundColor(AppColors.accent)
            VStack(alignment: .leading, spacing: 0) {
                Text(label).font(AppTypography.caption).foregroundColor(AppColors.secondaryText)
                Text(value).font(AppTypography.body).foregroundColor(AppColors.primaryText)
            }
        }
    }
}

public struct ForecastItemVM: Identifiable {
    public let id = UUID(); public let day: String; public let min: Int; public let max: Int; public let symbol: String
    public init(day: String, min: Int, max: Int, symbol: String) { self.day = day; self.min = min; self.max = max; self.symbol = symbol }
}

public struct ForecastPill: View {
    let vm: ForecastItemVM
    public init(_ vm: ForecastItemVM) { self.vm = vm }
    public var body: some View {
        VStack(spacing: 6) {
            Text(vm.day).font(AppTypography.caption).foregroundColor(AppColors.secondaryText)
            Image(systemName: vm.symbol).imageScale(.large).foregroundColor(AppColors.accent)
            HStack(spacing: 4) {
                Text("\(vm.max)°").font(.footnote).foregroundColor(AppColors.primaryText)
                Text("/ \(vm.min)°").font(.footnote).foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.vertical, Spacing.sm)
        .frame(width: 68)
        .background(AppColors.card)
        .cornerRadius(Radius.md)
        .shadow(color: Shadows.soft, radius: 6, x: 0, y: 4)
    }
}

public struct ForecastStrip: View {
    let items: [ForecastItemVM]
    public init(items: [ForecastItemVM]) { self.items = items }
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.md) {
                ForEach(items) { ForecastPill($0) }
            }.padding(.horizontal, Spacing.md)
        }
    }
}

public struct WeatherCard: View {
    let city: String; let tempC: Int; let condition: String; let feelsLikeC: Int; let humidity: Int; let windKph: Int; let isCached: Bool
    public init(city: String, tempC: Int, condition: String, feelsLikeC: Int, humidity: Int, windKph: Int, isCached: Bool = false) {
        self.city = city; self.tempC = tempC; self.condition = condition; self.feelsLikeC = feelsLikeC
        self.humidity = humidity; self.windKph = windKph; self.isCached = isCached
    }
    private var iconName: String {
        let s = condition.lowercased()
        if s.contains("rain") { return "cloud.rain.fill" }
        if s.contains("storm") || s.contains("thunder") { return "cloud.bolt.rain.fill" }
        if s.contains("snow") { return "cloud.snow.fill" }
        if s.contains("mist") || s.contains("fog") { return "cloud.fog.fill" }
        if s.contains("cloud") { return "cloud.fill" }
        return "sun.max.fill"
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(city).font(AppTypography.h2).foregroundColor(AppColors.primaryText)
                    Text("Now").font(AppTypography.caption).foregroundColor(AppColors.secondaryText)
                }
                Spacer()
                if isCached { Tag("Offline") }
            }
            HStack(spacing: Spacing.lg) {
                WeatherIcon(system: iconName, size: 64)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(tempC)°").font(AppTypography.h1).foregroundColor(AppColors.primaryText)
                    Text(condition).font(AppTypography.body).foregroundColor(AppColors.secondaryText)
                }
                Spacer()
            }
            HStack(spacing: Spacing.xl) {
                LabeledStat(icon: "thermometer", label: "Feels", value: "\(feelsLikeC)°")
                LabeledStat(icon: "drop.fill",     label: "Humidity", value: "\(humidity)%")
                LabeledStat(icon: "wind",          label: "Wind", value: "\(windKph) km/h")
            }
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.card)
        .cornerRadius(Radius.lg)
        .shadow(color: Shadows.soft, radius: 10, x: 0, y: 6)
    }
}
