import SwiftUI

struct GameView: View {
    // MARK: Properties

    @ObservedObject var viewModel = GameViewModel()

    // MARK: UI

    var body: some View {
        VStack {
            recordButton(isStarted: viewModel.isStarted)

            Spacer()

            VStack {
                Spacer()
                circleImage()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut, value: viewModel.circleMoveVertical)
    }

    // MARK: UI Components

    private func recordButton(isStarted: Bool) -> some View {
        Button {
            isStarted
            ? viewModel.stop()
            : viewModel.start()
        } label: {
            Image(systemName: isStarted ? "stop.fill" : "circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
                .foregroundColor(.red)
                .padding(.bottom, 40)
        }
    }

    private func circleImage() -> some View {
        Image("sphere")
            .resizable()
            .frame(width: 50, height: 50)
            .offset(x: viewModel.circleMoveHorizontal, y: viewModel.circleMoveVertical)
            .shadow(radius: 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
