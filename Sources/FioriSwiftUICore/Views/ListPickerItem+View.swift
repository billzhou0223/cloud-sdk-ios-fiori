import Foundation
import SwiftUI

// FIXME: - Implement Fiori style definitions

extension Fiori {
    enum ListPickerItem {
        struct Key: ViewModifier {
            func body(content: Content) -> some View {
                content.font(.headline).foregroundColor(.preferredColor(.primaryLabel))
            }
        }

        typealias KeyCumulative = EmptyModifier
        
        typealias Value = EmptyModifier
        typealias ValueCumulative = EmptyModifier
        
        static let key = Key()
        static let value = Value()
        static let keyCumulative = KeyCumulative()
        static let valueCumulative = ValueCumulative()
    }
}

// FIXME: - Implement ListPickerItem View body

extension ListPickerItem: View {
    public var body: some View {
        if isTopLevel {
            Button {
                showingSheet.toggle()
            } label: {
                NavigationLink(destination: EmptyView()) {
                    row
                }
            }
            .sheet(isPresented: $showingSheet) {
                NavigationView {
                    destinationView
                }
            }
        } else {
            NavigationLink(
                destination: destinationView,
                label: {
                    row
                }
            )
        }
    }
    
    var row: some View {
        KeyValueItem {
            key
        } value: {
            value
        }
    }
}

public extension ListPickerItem {
    /// Returns a list picker item with given configuration.
    /// - Parameters:
    ///   - key: The key view of the list.
    ///   - value: The value view of the list.
    ///   - configuration: The configuration for constructing the list picker.
    init(
        @ViewBuilder key: @escaping () -> Key,
        @ViewBuilder value: @escaping () -> Value,
        configuration: ListPickerItemConfiguration? = nil
    ) {
        self.init(key: key, value: value)
        
        if let configuration = configuration {
            destinationView = configuration.destinationView
        }
    }
}

private extension ListPickerItem {
    /// Returns a list picker item with given configuration.
    /// - Parameters:
    ///   - key: The key view of the list.
    ///   - value: The value view of the list.
    ///   - configuration: The configuration for constructing the list picker.
    init(
        @ViewBuilder key: @escaping () -> Key,
        @ViewBuilder value: @escaping () -> Value,
        configuration: ListPickerItemConfiguration? = nil,
        isTopLevel: Bool
    ) {
        self.init(key: key, value: value)
        self.isTopLevel = isTopLevel
        
        if let configuration = configuration {
            destinationView = configuration.destinationView
        }
    }
}

/// The configuration for constructing the list picker.
public struct ListPickerItemConfiguration {
    let destinationView: AnyView
    
    /// Creates a configuration object from a collection of data which supports both signle-level and multi-level picker with the ability to select multiple items.
    /// - Parameters:
    ///   - data: The data for constructing the list picker.
    ///   - id: The key path to the data model's unique identifier.
    ///   - children: The key path to the optional property of a data element whose value indicates the children of that element.
    ///   - selection: A binding to a set which stores the selected items.
    ///   - rowContent: The view builder which returns the content of each row in the list picker.
    public init<Data, ID, RowContent>(_ data: Data,
                                      id: KeyPath<Data.Element, ID>,
                                      children: KeyPath<Data.Element, Data?>?,
                                      selection: Binding<Set<ID>>?,
                                      @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent)
        where Data: RandomAccessCollection, RowContent: View, ID: Hashable
    {
        self.init(data, id: id, children: children, selection: selection, rowContent: rowContent, searchFilter: nil, isTopLevel: true)
    }
    
    /// Creates a configuration object from a collection of data (conforms to `Identifiable`) which supports both single-level and multi-level picker with the ability to select multiple items.
    /// - Parameters:
    ///   - data: The data for constructing the list picker.
    ///   - children: The key path to the optional property of a data element whose value indicates the children of that element.
    ///   - selection: A binding to a set which stores the selected items.
    ///   - rowContent: The view builder which returns the content of each row in the list picker.
    public init<Data, ID, RowContent>(_ data: Data,
                                      children: KeyPath<Data.Element, Data?>?,
                                      selection: Binding<Set<ID>>?,
                                      @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent)
        where Data: RandomAccessCollection, RowContent: View, Data.Element: Identifiable, ID == Data.Element.ID
    {
        let id = \Data.Element.id
        self.init(data, id: id, children: children, selection: selection, rowContent: rowContent)
    }
    
    public init<Data, ID, RowContent>(_ data: Data,
                                      id: KeyPath<Data.Element, ID>,
                                      children: KeyPath<Data.Element, Data?>?,
                                      selection: Binding<Set<ID>>?,
                                      @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent,
                                      searchFilter: ((Data.Element, String) -> Bool)?)
        where Data: RandomAccessCollection, RowContent: View, ID: Hashable
    {
        self.init(data, id: id, children: children, selection: selection, rowContent: rowContent, searchFilter: searchFilter, isTopLevel: true)
    }
}

public extension ListPickerItemConfiguration {
    /// Creates a configuration object from a collection of `String` which supports both single-level and multi-level picker with the ability to select multiple items.
    /// - Parameters:
    ///   - data: An array of strings for constructing the list.
    ///   - selection: A binding to a set which stores the selected items.
    init(_ data: [String], selection: Binding<Set<String>>?) {
        self.init(data, id: \.self, children: nil, selection: selection) { str in
            Text(str)
        }
    }
}

private extension ListPickerItemConfiguration {
    init<Data, ID, RowContent>(_ data: Data,
                               id: KeyPath<Data.Element, ID>,
                               children: KeyPath<Data.Element, Data?>?,
                               selection: Binding<Set<ID>>?,
                               @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent,
                               searchFilter: ((Data.Element, String) -> Bool)? = nil,
                               isTopLevel: Bool)
        where Data: RandomAccessCollection, RowContent: View, ID: Hashable
    {
        self.destinationView = SearchableListView(data, id: id, children: children, selection: selection, rowContent: rowContent, searchFilter: searchFilter, isTopLevel: isTopLevel).typeErased
    }
}

extension ListPickerItem {
    struct Row<ID: Hashable>: View where Value == EmptyView {
        private let content: Key
        private let id: ID
        @Binding private var selection: Set<ID>
        
        init(content: Key, id: ID, selection: Binding<Set<ID>>?) {
            self.content = content
            self.id = id
            self._selection = selection ?? Binding.constant(Set<ID>())
        }
        
        var body: some View {
            let isSelected = selection.contains(id)
            
            HStack {
                content
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.preferredColor(.tintColor))
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if isSelected {
                    selection.remove(id)
                } else {
                    selection.insert(id)
                }
            }
        }
    }
}

public struct SearchableListView<Data: RandomAccessCollection, RowContent: View, ID: Hashable>: View {
    @State private var search: String = ""
    @State private var _selections: Set<ID>
    @Environment(\.presentationMode) private var presentationMode
    
    let data: Data
    let id: KeyPath<Data.Element, ID>
    let children: KeyPath<Data.Element, Data?>?
    let selection: Binding<Set<ID>>?
    @ViewBuilder let rowContent: (Data.Element) -> RowContent
    let searchFilter: ((Data.Element, String) -> Bool)?
    
    private let isTopLevel: Bool
    
    public init(_ data: Data,
                id: KeyPath<Data.Element, ID>,
                children: KeyPath<Data.Element, Data?>?,
                selection: Binding<Set<ID>>?,
                @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent,
                searchFilter: ((Data.Element, String) -> Bool)? = nil)
    {
        self.init(data, id: id, children: children, selection: selection, rowContent: rowContent, isTopLevel: true)
    }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            bodyView
                .searchable(text: $search)
        } else {
            bodyView
        }
    }
    
    @ViewBuilder
    var bodyView: some View {
        if isTopLevel {
            listView
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Confirm") {
                            selection?.wrappedValue = _selections
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        } else {
            listView
        }
    }
    
    var listView: some View {
        List {
            ForEach(data.filter {
                if searchFilter == nil || search.isEmpty {
                    return true
                } else {
                    return searchFilter!($0, search)
                }
            }, id: id) { element in
                let row = rowContent(element)
                let id_value = element[keyPath: id]
                let selection = isTopLevel ? $_selections : selection
                
                if let children = children, let childrenData = element[keyPath: children] {
                    ListPickerItem<RowContent, EmptyView>(key: {
                        row
                    }, value: {
                        EmptyView()
                    }, configuration: {
                        ListPickerItemConfiguration(childrenData, id: id, children: children, selection: selection, rowContent: rowContent, searchFilter: searchFilter, isTopLevel: false)
                    }(), isTopLevel: false)
                } else {
                    ListPickerItem.Row(content: row, id: id_value, selection: selection)
                }
            }
        }
    }
}

private extension SearchableListView {
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         children: KeyPath<Data.Element, Data?>?,
         selection: Binding<Set<ID>>?,
         @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent,
         searchFilter: ((Data.Element, String) -> Bool)? = nil,
         isTopLevel: Bool)
    {
        self.data = data
        self.id = id
        self.children = children
        self.selection = selection
        self.rowContent = rowContent
        self.searchFilter = searchFilter
        self.isTopLevel = isTopLevel
        self.__selections = State(initialValue: selection?.wrappedValue ?? [])
    }
}
