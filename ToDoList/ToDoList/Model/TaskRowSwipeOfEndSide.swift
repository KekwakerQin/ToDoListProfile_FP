import SwiftUI

struct TaskRowSwipeOfEndSide: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var offset: CGFloat = 0 // Для отслеживания свайпа
    @GestureState private var gestureOffset: CGFloat = 0 // Временное значение свайпа
    
    var body: some View {
        ZStack {
            // Фон с кнопками
            HStack {
                Spacer()
                Button(role: .destructive) {
                    withAnimation {
                        offset = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if let index = viewModel.tasks.firstIndex(of: <#String#>) {
                                viewModel.removeTask(at: index)
                            }
                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                        .frame(maxHeight: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 8)
            }

            // Основной контент задачи
            Text(task)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .background(Color.white)
                .offset(x: offset + gestureOffset)
                .gesture(
                    DragGesture()
                        .updating($gestureOffset) { value, state, _ in
                            let isSwipeFromRight = value.startLocation.x > UIScreen.main.bounds.width * 0.75
                            if isSwipeFromRight {
                                state = value.translation.width
                            }
                        }
                        .onEnded { value in
                            let isSwipeFromRight = value.startLocation.x > UIScreen.main.bounds.width * 0.75
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)) {
                                if isSwipeFromRight {
                                    if value.translation.width < -100 {
                                        offset = -100 // Открываем меню
                                    } else {
                                        offset = 0 // Возвращаем на место
                                    }
                                }
                            }
                        }
                )
        }
        .animation(.easeInOut, value: offset) // Глобальная анимация для offset
    }
}
