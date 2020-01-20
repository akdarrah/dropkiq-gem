module Dropkiq
  DEFAULT_DROP_PATH = "/app/drops"
  DEFAULT_MODEL_PATH = "/app/models"

  DEFAULT_LIQUID_DROP_CLASSES = [
    Liquid::ForloopDrop,
    Liquid::TablerowloopDrop
  ]

  BOOLEAN_TYPE   = "ColumnTypes::Boolean"
  DATE_TIME_TYPE = "ColumnTypes::DateTime"
  HAS_MANY_TYPE  = "ColumnTypes::HasMany"
  HAS_ONE_TYPE   = "ColumnTypes::HasOne"
  NUMERIC_TYPE   = "ColumnTypes::Numeric"
  STRING_TYPE    = "ColumnTypes::String"
  TEXT_TYPE      = "ColumnTypes::Text"
  YAML_TYPE      = "ColumnTypes::YAML"
end
