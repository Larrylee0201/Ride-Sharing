//
//  Ride_SharingApp.swift
//  Ride_Sharing
//
//  Created by Larry on 4/22/24.
//

import SwiftUI

@main
struct Ride_SharingApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}


struct SplashScreen: View {
    @State private var isActive = false
    @State private var opacity = 0.0 // 初始透明度为0，即完全透明

    var body: some View {
        VStack {
            // Your splash screen content here
            Image(systemName: "car.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .opacity(opacity) // 根据 opacity 控制图片的透明度
            
            Text("Ride-Sharing")
                .fontWeight(.bold)
                .font(.title)
                .padding()
                .opacity(opacity) // 根据 opacity 控制文本的透明度
        }
        .onAppear {
            // 使用 withAnimation 实现渐入效果
            withAnimation(.easeInOut(duration: 1.0)) {
                opacity = 1.0 // 将透明度从0渐变为1，实现淡入效果
            }
            // 添加一个延迟，在淡入完成后延迟1秒后执行
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // 使用 withAnimation 实现渐出效果
                withAnimation(.easeInOut(duration: 1.0)) {
                    opacity = 0.0 // 将透明度从1渐变为0，实现淡出效果
                }
                // 动画结束后将 isActive 设置为 true，触发跳转到 ContentView
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive, content: ContentView.init)
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        // 使用.constant(true)来提供一个临时的绑定值
        SplashScreen()
    }
}


