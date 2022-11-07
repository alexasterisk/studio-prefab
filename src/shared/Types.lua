export type Map<K, V> = {[K]: V}
export type Array<V> = {[number]: V}
export type Group<T> = Map<string, T>
export type Iterable<T, I> = T & Map<string, I>
export type UnionOrPart = UnionOperation | Part | Model
export type Light = PointLight | SpotLight | SurfaceLight

------------ UTILITY

export type Character = Model & {
    Humanoid: Humanoid,
    HumanoidRootPart: Part
}

return {}