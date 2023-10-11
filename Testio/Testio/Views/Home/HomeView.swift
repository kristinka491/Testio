//
//  HomeView.swift
//  Testio
//
//  Created by Krystsina on 2023-10-10.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var testioViewModel: TestioViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var showFilterSheet: Bool = false
    
    var body: some View {
        if viewModel.isLoading {
            LoaderView()
                .onAppear {
                    viewModel.loadData()
                }
        } else {
            homeView()
        }
    }
    
    private func homeView() -> some View {
        NavigationStack {
            VStack(spacing: .zero) {
                Divider()
                
                HStack(spacing: .zero) {
                    Text(StringConstants.serverLabel)
                        .font(.system(size: 14))
                        .foregroundColor(.labelColor)
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    Text(StringConstants.distanceLabel)
                        .font(.system(size: 14))
                        .foregroundColor(.labelColor)
                        .padding(.trailing, 38)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                .padding(.bottom, 8)
                .background(Color.lightGrayColor)
                .padding(.horizontal, .zero)
               
                List(viewModel.listOfLocations, id: \.name) { item in
                    itemCell(item: item)
                }
                .listStyle(PlainListStyle())
                
                Spacer()
            }
            .navigationTitle(StringConstants.homeNavigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    filerButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    logoutButton()
                }
            }
        }
        .onChange(of: viewModel.selectedFilterType) { _ in
            viewModel.filterData()
        }
        .onChange(of: viewModel.isUserLogout) { isUserLogout in
            if isUserLogout {
                testioViewModel.isUserLoggedIn.toggle()
            }
        }
        .confirmationDialog("", isPresented: $showFilterSheet) {
            ForEach(HomeViewModel.FilterType.allCases) { type in
                Button(type.title) {
                    viewModel.selectedFilterType = type
                }
            }
        }
    }
    
    private func filerButton() -> some View {
        Button {
            showFilterSheet.toggle()
        } label: {
            HStack {
                Image("sortIcon")
                Text(StringConstants.fileterButton)
            }
        }
    }
    
    private func logoutButton() -> some View {
        Button {
            viewModel.logout()
            testioViewModel.isUserLoggedIn.toggle()
        } label: {
            HStack {
                Text(StringConstants.logoutButton)
                Image("logoutIcon")
            }
        }
    }
    
    private func itemCell(item: Location) -> some View {
        HStack(spacing: .zero) {
            Text(item.name)
                .font(.system(size: 17))
            
            Spacer()
            
            Text("\(item.distance)")
                .font(.system(size: 17))
                .padding(.trailing, 26)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
