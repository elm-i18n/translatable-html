export namespace Elm {
	namespace Main {
		interface App {
			ports: Record<string, never>
		}

		function init(options: { node?: HTMLElement | null }): Elm.Main.App;
	}
}
