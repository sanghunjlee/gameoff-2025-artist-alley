class_name SkillInventory extends Resource

@export var skills: Array[SkillResource] = []

func has_skil(skill: SkillResource):
    return skills.has(skill)