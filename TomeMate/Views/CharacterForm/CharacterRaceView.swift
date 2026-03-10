import SwiftUI

struct CharacterRaceView: View {
    @StateObject var viewModel = RacesViewModel()
    
    @Binding var formData: CharacterFormData
    @Binding var currentPage: Int
    @Binding var isDisabled: Bool
    
    @State private var selectedRace: RaceModel? = nil
    @State private var sheetRace: RaceModel? = nil

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select your Race")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.races) { race in
                        RaceCards(race: race, selectedRace: selectedRace)
                            .onTapGesture {
                                selectedRace = race
                                formData.race = race
                                NetworkManager.shared.fetchSubraces(query: race.name) { result in
                                    if case .success(let subraces) = result, !subraces.isEmpty {
                                        sheetRace = race
                                    }
                                }
                            }
                            .padding()
                    }
                }
            }
        }
        .onAppear {                         // moved here
            selectedRace = formData.race
            if formData.subrace == nil {
                isDisabled = true
            }
            else{
                isDisabled = false
            }
        }
        .sheet(item: $sheetRace) { selectedRace in
            SubraceView(selectedRace: selectedRace, formData: $formData, currentPage: $currentPage)
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
  //  Page2()
}


struct RaceCards: View {
    let race: RaceModel
    var selectedRace: RaceModel? = nil
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 130, height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedRace == race ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .overlay {
                VStack(spacing: 6) {
                    Spacer()
                    Text(race.name)
                        .font(.headline)
                    Text(race.languages.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(8)
            }
            .padding(4)
    }
}


struct SubraceView: View {
    let selectedRace: RaceModel
    @Binding var formData: CharacterFormData
    @StateObject var viewModel = SubracesViewModel()
    @Binding var currentPage: Int
    @State private var selectedSubrace: SubraceModel? = nil
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select a Subrace")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.subraces) { subrace in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                            .frame(width: 120, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedSubrace == subrace ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .overlay {
                                Text(subrace.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(4)
                            }
                            .onTapGesture {
                                selectedSubrace = subrace
                                formData.subrace = subrace
                                dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    currentPage += 1
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.fetchSubraces(raceName: selectedRace.name)
            }
        }
    }
}
