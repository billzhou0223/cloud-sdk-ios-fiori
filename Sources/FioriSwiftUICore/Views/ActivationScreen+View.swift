/// - Important: to make `@Environment` properties (e.g. `horizontalSizeClass`), internally accessible
/// to extensions, add as sourcery annotation in `FioriSwiftUICore/Models/ModelDefinitions.swift`
/// to declare a wrapped property
/// e.g.:  `// sourcery: add_env_props = ["horizontalSizeClass"]`

import FioriThemeManager
import SwiftUI

extension Fiori {
    enum ActivationScreen {
        struct Title: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(.system(size: 28, weight: .thin, design: .default))
                    .foregroundColor(.preferredColor(.primary1))
                    .multilineTextAlignment(.center)
            }
        }

        typealias TitleCumulative = EmptyModifier
        struct DescriptionText: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(.system(size: 17))
                    .foregroundColor(.preferredColor(.primary1))
                    .multilineTextAlignment(.center)
            }
        }

        typealias DescriptionTextCumulative = EmptyModifier
        struct TextFilled: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(.system(size: 15))
                    .foregroundColor(.preferredColor(.primary1))
            }
        }

        typealias TextFilledCumulative = EmptyModifier

        struct ActionText: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .buttonStyle(FioriButtonStyle())
            }
        }

        typealias ActionTextCumulative = EmptyModifier
        struct Footnote: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(.system(size: 15))
                    .foregroundColor(.preferredColor(.primary1))
            }
        }

        typealias FootnoteCumulative = EmptyModifier
        struct SecondaryActionText: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(.system(size: 15))
                    .foregroundColor(.preferredColor(.primary1))
            }
        }

        typealias SecondaryActionTextCumulative = EmptyModifier
        static let title = Title()
        static let descriptionText = DescriptionText()
        static let textFilled = TextFilled()
        static let actionText = ActionText()
        static let footnote = Footnote()
        static let secondaryActionText = SecondaryActionText()
        static let titleCumulative = TitleCumulative()
        static let descriptionTextCumulative = DescriptionTextCumulative()
        static let textFilledCumulative = TextFilledCumulative()
        static let actionTextCumulative = ActionTextCumulative()
        static let footnoteCumulative = FootnoteCumulative()
        static let secondaryActionTextCumulative = SecondaryActionTextCumulative()
    }
}

extension ActivationScreen: View {
    public var body: some View {
        VStack {
            title
                .padding(.top, 40)
                .padding(.bottom, 40)
            descriptionText
                .padding(.bottom, 40)
            
            textFilled
                .multilineTextAlignment(.center)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .padding(.top, 15)
                .padding(.bottom, 20)
            
            actionText
                .padding(.bottom, 16)
            
            footnote
                .padding(.bottom, 16)
            secondaryActionText
                .buttonStyle(FioriButtonStyle())
            Spacer()
        }
        .padding(.leading, 32)
        .padding(.trailing, 32)
    }
}