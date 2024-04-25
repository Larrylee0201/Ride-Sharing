//
//  Post.swift
//  Ride_Sharing
//
//  Created by Larry on 4/22/24.
//

import SwiftUI

// Post模型
struct Post: Identifiable {
    var id = UUID()
    var username: String
    var title: String
    var content: String
    var imageURL: String? // 可选的图片URL
    var timestamp: Date = Date() // 发布时间
    var departure: String // 出发地
    var destination: String // 目的地
    var departureTime: Date // 出发时间
    var expirationDate: Date // 帖子过期时间
}



// 自定义按钮样式
struct FilledRoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// 发布帖子的视图
struct CreatePostView: View {
    @Binding var posts: [Post]
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var imageURL: String = ""
    @State private var departure: String = ""
    @State private var destination: String = ""
    @State private var departureTime: Date = Date()
    @State private var expirationDate: Date = Date()
    var username: String

    var body: some View {
        Form {
            Section(header: Text("Post Details")) {
                TextField("Title", text: $title)
                TextField("Detail...", text: $content)
                TextField("Image URL (optional)", text: $imageURL)
            }

            Section(header: Text("Travel Details")) {
                TextField("Departure place", text: $departure)
                TextField("Destination", text: $destination)
                DatePicker("Departure time", selection: $departureTime, displayedComponents: .date)
            }

            DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)

                        Button("Post") {
                            let newPost = Post(username: username, title: title, content: content, imageURL: imageURL, departure: departure, destination: destination, departureTime: departureTime, expirationDate: expirationDate)
                            posts.append(newPost)
                            // Reset the form
                            title = ""
                            content = ""
                            imageURL = ""
                            departure = ""
                            destination = ""
                        }
                        .buttonStyle(FilledRoundedButtonStyle())
                        .disabled(title.isEmpty || content.isEmpty || departure.isEmpty || destination.isEmpty)
                    }
                }
            }



// 帖子详情视图
struct PostView: View {
    var post: Post

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.title)
                    .padding(.bottom, 5)

                if let imageUrl = post.imageURL, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image.resizable().aspectRatio(contentMode: .fit)
                        } else if phase.error != nil {
                            Text("Unable to load image").foregroundColor(.red)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(maxWidth: 300, maxHeight: 300)
                    .cornerRadius(10)
                    .padding(.bottom, 5)
                }

                Text(post.content)
                    .font(.body)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading) {
                    Text("Departure: \(post.departure)")
                    Text("Destination: \(post.destination)")
                    Text("Departure Time: \(post.departureTime, formatter: dateFormatter)")
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.vertical, 5)

                Text("Posted at: \(post.timestamp, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
}



// 主视图，包括帖子列表和导航到发布界面的链接
struct PostcardView: View {
    @State private var posts: [Post] = []
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // 每分钟检查一次

    var body: some View {
        NavigationView {
            List(posts.filter { $0.expirationDate > Date() }) { post in  // 过滤掉已过期的帖子
                NavigationLink(destination: PostView(post: post)) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(post.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(post.content)
                            .font(.subheadline)
                            .lineLimit(3)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                NavigationLink("New Post", destination: CreatePostView(posts: $posts, username: "CurrentUsername"))
            }
            .onReceive(timer) { _ in
                self.posts.removeAll { $0.expirationDate <= Date() } // 实时移除过期的帖子
            }
        }
    }
}



struct PostcardView_Previews: PreviewProvider {
    static var previews: some View {
        PostcardView()
    }
}
