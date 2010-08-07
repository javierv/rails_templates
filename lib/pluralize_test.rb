# encoding: utf-8

require 'test_helper'

class PluralizeTest < ActiveSupport::TestCase

  test "el plural de una palabra acabada en vocal se hace con una 's'" do
    assert_equal 'libros', 'libro'.pluralize
    assert_equal 'libro', 'libros'.singularize
  end

  test "el plural de una palabra que acaba en consonante es -es" do
    assert_equal 'autores', 'autor'.pluralize
    assert_equal 'autor', 'autores'.singularize
  end

  test "las palabras acabadas en 'z' hacen su plural en 'ces'" do
    assert_equal 'veces', 'vez'.pluralize
    assert_equal 'vez', 'veces'.singularize
  end

  test "las palabras agudas acabadas en 'n' ó 's' hacen el plural sin acento" do
    assert_equal 'balcones', 'balcón'.pluralize
    assert_equal 'truhanes', 'truhán'.pluralize
    assert_equal 'cordobeses', 'cordobés'.pluralize
    assert_equal 'cojines', 'cojín'.pluralize
    assert_equal 'trolebuses', 'trolebús'.pluralize
    #assert_equal 'balcón', 'balcones'.singularize Peligros, ya que en la BD los nombres de tabla no tienen acentos
  end

  test "las palabras acabadas en vocal débil con acento más consonante conservan el acento" do
    assert_equal 'raíces', 'raíz'.pluralize
    assert_equal 'raíz', 'raíces'.singularize

    assert_equal 'baúles', 'baúl'.pluralize
    assert_equal 'baúl', 'baúles'.singularize
  end

  #TODO: cacahuete => cacahuetes. Ver en qué consonantes pueden acabar las palabras españolas.

  test "las palabras acabadas en vocal cerrada con acento hace su plural en -es" do
    assert_equal 'manatíes', 'manatí'.pluralize
    assert_equal 'manatí', 'manatíes'.singularize

    assert_equal 'tabúes', 'tabú'.pluralize
    assert_equal 'tabú', 'tabúes'.singularize
  end

  test "las palabras agudas acabadas en vocal abierta hacen su plural en -s" do
    assert_equal 'sofás', 'sofá'.pluralize
    assert_equal 'sofá', 'sofás'.singularize

    assert_equal 'comités', 'comité'.pluralize
    assert_equal 'comité', 'comités'.singularize

    assert_equal 'platós', 'plató'.pluralize
    assert_equal 'plató', 'platós'.singularize
  end
end